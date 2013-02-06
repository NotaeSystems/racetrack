class Race < ActiveRecord::Base
  has_many :horses, :dependent => :destroy
  belongs_to :card
  belongs_to :meet
  belongs_to :track
  has_many :bets,  :dependent => :destroy
  has_many :gates,  :dependent => :destroy
  has_many :winning_bets, :class_name => 'Bet'
  has_many :comments,  :dependent => :destroy 
  has_many :rankings,  :dependent => :destroy
  has_many :offers, :dependent => :destroy
  has_many :contracts, :dependent => :destroy

  validates_presence_of :name
  validates :initial_credits, :numericality => true
  after_save :update_gates

  attr_accessible :card_id, :completed, :completed_date, :description, :name, :open, :post_time, 
                  :start_betting_time, :status, :track_id, :win, :place, :show, :exacta, :trifecta, 
                  :level, :morning_line, :results, :meet_id, :back, :lay, :odds , :exchange, :initial_credits


  def update_gates
    RacesPusher.new(self).update_gates(self).push

  end


  def open?
   betting_status == 'Open'
  end

  def cancel
      self.bets.where(:status => 'Pending').each do |bet|
        Credit.create(:user_id => bet.user_id,
                           :meet_id => bet.meet_id,
                           :amount => bet.amount,
                           :description => "#{self.name}--Canceled. Returned bet.",
                           :card_id => self.card_id,
                           :credit_type => "Race cancelled",
                           :level => bet.level,
                           :track_id => self.track_id
                             ) 
       bet.status = 'Cancelled'
       bet.amount = 0

       bet.save
       bet.user.update_ranking(self.card.meet.id, bet.amount)
     end
       self.status = 'Cancelled'
       self.save
  end

  def betting_status
    return 'Paid Out' if self.status == 'Paid Out'
    return 'Closed' if self.status == 'Closed'
    return 'Finished' if self.status == 'Finished'

    ## check card status
    return 'Closed Card' if self.card.status == 'Closed'
    return 'Pending Card' if self.card.status == 'Pending'

    ## if race is open then check for other conditions 
    return 'Pending Race' if self.status == 'Pending'
    return 'Pending Payout' if self.status == 'Pending Payout'

    return 'Past Post Time' if self.post_time.to_datetime < Time.now.to_datetime


    return 'Pending Start Time' if self.start_betting_time.to_datetime > Time.now.to_datetime


    return 'Open'
  end


  def total_bets(bet_type =  nil)
   if bet_type
    self.bets.where(:bet_type => bet_type, :status => 'Pending').sum(:amount)  
   else
    self.bets.sum(:amount)  
   end
  end

  def settle_contracts
    card = self.card
    meet =self.meet
    track = self.track
    
    winner = self.gates.where("finish = 1").first
    ### find all buy contracts and create bets  credit 100 points
    contracts = Contract.where("gate_id = ? and contract_type = 'Owner' and status = 'Open'", winner.id)
    contracts.each do |contract|
        if contract.level == 'Yellow'
          win_level = 'White'
        elsif contract.level == 'White'
          win_level = 'Red'
        elsif contract.level == 'Red'
          ## TODO add black win level
          win_level = 'Red'
        end
        credit = Credit.create(:user_id => contract.user_id,
                           :meet_id => meet.id,
                           :amount => 100,
                           :description => "Winnings on Contract Option",
                           :card_id => card.id,
                           :credit_type => "Contract Option Winnings",
                           :track_id => track.id,
                           :site_id => track.site.id,
                           :race_id => self.id,
                           :level => win_level
                             ) 
      contract.status = 'Settled'
      contract.save
      contract.user.update_race_ranking(self, 100, 'Red')
           
    end
    ### find all sellers contracts on the winners and deduct the contract amount
    contracts = Contract.where("gate_id = ? and contract_type = 'Seller' and status = 'Open'", winner.id)
    contracts.each do |contract|
        credit = Credit.create(:user_id => contract.user_id,
                           :meet_id => meet.id,
                           :amount => -100,
                           :description => "Loss on Contract Sell",
                           :card_id => card.id,
                           :credit_type => "Contract Sell Losses",
                           :track_id => track.id,
                           :site_id => track.site.id,
                           :race_id => self.id,
                           :level => 'White'
                             )
      contract.status = 'Settled'
      contract.save
      contract.user.update_race_ranking(self, -100, 'White')        
    end
    #### all other contracts are settled
    contracts = Contract.where("race_id = ? and status = 'Open'", self.id)
    contracts.update_all(:status => 'Closed')
  end

  def payout

    # find winners
    winners = self.gates.where("finish = 1")
    win_pot = self.bets.where("bet_type = 'Win' and status = 'Pending'").sum(:amount)
    winners_size = winners.size

    ### placers
    placers = self.gates.where("finish IN (1,2)")
    place_pot = self.bets.where("bet_type = 'Place' and status = 'Pending'").sum(:amount)
    placers_size = placers.size

    ###showers
    showers = self.gates.where("finish IN (1,2,3)")
    show_pot = self.bets.where("bet_type = 'Show' and status = 'Pending'").sum(:amount)
    showers_size = showers.size
    #################


    total_pot = self.bets.where("status = 'Pending'").sum(:amount)


    logger.debug "################# total_pot = #{total_pot} Closing odds:  winners_size: #{winners_size} winners pot: #{win_pot} placers_size: #{placers_size} placers pot: #{place_pot} showers_size: #{showers_size} showers pot: #{show_pot} \n"
    ## payout winners
    payout_bets('Win', winners, win_pot)
    payout_bets('Place', placers, place_pot)
    payout_bets('Show', showers, show_pot)

    #### exacta
      logger.debug "##################  Getting ready to pay out Exacta"
    logger.debug "################## exacta = #{self.exacta} "
    if self.exacta?
      logger.debug "##################  Inside Exacta"
      exacta_pot = 0
      exacta_winners = nil
      winner = self.gates.where("finish = 1").first
      place = self.gates.where("finish = 2").first

      unless winner.blank?  || place.blank?
      logger.debug "################## Winner was #{winner.name} Place was #{place.name}"
        exacta_winners = self.bets.where(:bet_type => 'Exacta', :win_id => winner.id, :place_id => place.id, :status => 'Pending')
        exacta_pot = self.bets.where(:bet_type => 'Exacta',:status => 'Pending').sum(:amount) 
      logger.debug "################## Exacta pot = #{exacta_pot}"
        payout_exacta_trifecta(exacta_winners, exacta_pot, 'Exacta')
      end
    end

    ##################
    #### trifecta
      logger.debug "##################  Getting ready to pay out Trifecta"
    logger.debug "################## trifecta = #{self.trifecta} "
    if self.trifecta?
      logger.debug "##################  Inside Exacta"
      trifecta_pot = 0
      trifecta_winners = nil
      winner = self.gates.where("finish = 1").first
      place = self.gates.where("finish = 2").first
      show = self.gates.where("finish = 3").first

      unless winner.blank?  || place.blank? || show.blank?
      logger.debug "################## Winner was #{winner.name} Place was #{place.name} Show was #{show.name}"
        trifecta_winners = self.bets.where(:bet_type => 'Trifecta', :win_id => winner.id, :place_id => place.id, :status => 'Pending')
        trifecta_pot = self.bets.where(:bet_type => 'Trifecta',:status => 'Pending').sum(:amount) 
      logger.debug "################## Trifecta pot = #{trifecta_pot}"
        payout_exacta_trifecta(trifecta_winners, trifecta_pot, 'Trifecta')
      end
    end

    ##################
    ## find all other red bets and reduce user standing
    losers = self.bets.where(:status => 'Pending', :level => 'Red')
    losers.each do |loser|
      bettor.update_card_ranking(gate.race.card, -won_bet_amount)

      user = loser.user
      user.amount = user.amount - loser.amount
      user.save
    end

    ## find all other bets and mark as Losing Bet
    losers = self.bets.where(:status => 'Pending')
    losers.update_all(:status => 'Losing Bet')
    
    self.status = 'Finished'
    self.save
  end
  

  def payout_exacta_trifecta(winning_bets, pot, bet_type)
    logger.debug "##################  Paying out #{bet_type}"
   # bet_type = 'Exacta'
    return if pot == 0
    return if winning_bets.blank?
    exacta_total_bets = winning_bets.sum(:amount)
    floated_odds = pot.to_f / exacta_total_bets.to_f
    exacta_odds = (floated_odds * 20).round.to_f/20
    logger.debug "odds = #{exacta_odds}\n"
    return if exacta_odds == 0
    winning_bets.each do |bet|
        bettor = bet.user
        bet_amount = bet.amount
        logger.debug "Exacta bet amount: #{bet_amount}\n"
        bet_payoff = bet_amount.to_f * exacta_odds
        won_bet_amount = bet_payoff - bet_amount
        logger.debug "Exacta bet payoff: #{bet_payoff}\n"
        # create Red credit for winnings horse_payoff
        if bet.level == 'Yellow'
          win_level = 'White'
        elsif bet.level == 'White'
          win_level = 'Red'
        elsif bet.level == 'Red'
          ## TODO add black win level
          win_level = 'Red'
        end
        Credit.create( :user_id => bet.user_id,
                   :meet_id => bet.meet_id,
                   :amount => won_bet_amount.round,
                   :credit_type => bet_type,
                   :card_id => card_id,
                   :description => "Winnings: #{self.name} on #{bet_type}",
                   :track_id => self.track_id,
                   :site_id => self.site_id, 
                   :level => win_level,
                   :race_id => self.id                
                 )
        ## return winning bet
        Credit.create( :user_id => bet.user_id,
                   :meet_id => bet.meet_id,
                   :amount => bet_amount,
                   :credit_type => bet_type,
                   :card_id => card_id,
                   :description => "Returned Winning Bet: #{self.name} on #{bet_type}",
                   :track_id => self.track_id,
                   :site_id => self.site_id, 
                   :level => self.level,
                   :race_id => self.id
                 
                 )
        bet.status = 'Paid Out'
        bet.save
          bettor.update_race_ranking(gate.race, won_bet_amount, 'Red')
         


    end

  end


  def payout_bets(bet_type, gates, pot)
    logger.debug "##################  Paying out #{bet_type}"
 
    gates.each do |gate|
      card_id = self.card_id
      logger.debug "#{bet_type} is #{gate.horse.name}"
      gate_total_bets = gate.total_bets
      logger.debug "#{bet_type} total bets = #{pot}\n"
      next if pot == 0
      #horse_odds = total_pot / winner_total_bets
      gates_total_bets = gate.total_bets(bet_type).to_f
      logger.debug "#{gates_total_bets} gates total bets \n"
      if  gates_total_bets < 1  ## 
      logger.debug "there are no bets on this gate \n"
        next
      end
      floated_odds = pot.to_f / gate.total_bets(bet_type).to_f
      gate_odds = (floated_odds * 100).round.to_f/100
      logger.debug "odds = #{gate_odds}\n"
      next if gate_odds == 0
      #payoff_odds = winner_odds / winners_size
      #logger.debug "payoff_odds = #{payoff_odds}\n"
      gate.bets.where(:status => 'Pending').each do |bet|
        bettor = bet.user
        bet_amount = bet.amount
        logger.debug "gate bet amount: #{bet_amount}\n"
        #horse = bet.horse
        bet_payoff = bet_amount.to_f * gate_odds
        won_bet_amount = bet_payoff - bet_amount
        logger.debug "#{bet_type} bet payoff: #{bet_payoff}\n"
        # create Red credit for winnings horse_payoff
        if bet.level == 'Yellow'
          win_level = 'White'
        elsif bet.level == 'White'
          win_level = 'Red'
        elsif bet.level == 'Red'
          ## TODO add black win level
          win_level = 'Red'
        end
        Credit.create( :user_id => bet.user_id,
                   :meet_id => bet.meet_id,
                   :amount => won_bet_amount,
                   :credit_type => bet_type,
                   :card_id => card_id,
                   :description => "Winnings: #{self.name} on #{bet_type} on #{gate.horse.name}",
                   :track_id => self.track_id,
                   :site_id => self.site_id,
                   :level => win_level,
                   :race_id => self.id
                 )
        ## update winnings for site leaderboard
        ## not needed?
        #bettor.amount = bettor.amount + won_bet_amount
        #bettor.save
        ## return winning bet
        Credit.create( :user_id => bet.user_id,
                   :meet_id => bet.meet_id,
                   :amount => bet_amount,
                   :credit_type => bet_type,
                   :card_id => card_id,
                   :description => "Returned Winning Bet: #{self.name} on #{bet_type} on #{gate.horse.name}",
                   :track_id => self.track_id,
                   :site_id => self.site_id,
                   :level => bet.level,
                   :race_id => self.id
                 )
        bet.status = 'Paid Out'
        bet.save
        if win_level == 'Red'
         # bettor.update_card_ranking(gate.race, won_bet_amount)
          logger.debug 'Getting ready to update race rankings'
          bettor.update_race_ranking(gate.race, won_bet_amount, 'Red')
        end
      end
    end

  end
end
