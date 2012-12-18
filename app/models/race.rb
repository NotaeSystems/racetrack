class Race < ActiveRecord::Base
  has_many :horses, :dependent => :destroy
  belongs_to :card
  belongs_to :track
  has_many :bets
  has_many :winning_bets, :class_name => 'Bet'
  has_many :comments   
  attr_accessible :card_id, :completed, :completed_date, :description, :name, :open, :post_time, 
                  :start_betting_time, :status, :track_id, :win, :place, :show



  def betting_status
    return 'Paid Out' if self.status == 'Paid Out'
    return 'Closed' if self.status == 'Closed'

    ## check card status
    return 'Closed' if self.card.status == 'Closed'
    return 'Pending' if self.card.status == 'Pending'

    ## if race is open then check for other conditions 
    return 'Pending' if self.status == 'Pending'

    return 'Finished' if self.post_time.to_datetime < Time.now.to_datetime


    return 'Pending' if self.start_betting_time.to_datetime > Time.now.to_datetime


    return 'Open'
  end


  def total_bets(bet_type =  nil)
   if bet_type
    self.bets.where(:bet_type => bet_type, :status => 'Pending').sum(:amount)  
   else
    self.bets.sum(:amount)  
   end
  end

  
  def payout
    # find winners
    winners = self.horses.where("finish = 1")
    win_pot = self.bets.where("bet_type = 'Win' and status = 'Pending'").sum(:amount)
    winners_size = winners.size

    ### placers
    placers = self.horses.where("finish IN (1,2)")
    place_pot = self.bets.where("bet_type = 'Place' and status = 'Pending'").sum(:amount)
    placers_size = placers.size

    ###showers
    showers = self.horses.where("finish IN (1,2,3)")
    show_pot = self.bets.where("bet_type = 'Show' and status = 'Pending'").sum(:amount)
    showers_size = showers.size
    #################

    total_pot = self.bets.where("status = 'Pending'").sum(:amount)


    logger.debug "################# total_pot = #{total_pot} Closing odds:  winners_size: #{winners_size} winners pot: #{win_pot} placers_size: #{placers_size} placers pot: #{place_pot} showers_size: #{showers_size} showers pot: #{show_pot} \n"
    ## payout winners
    payout_bets('Win', winners, win_pot)
    payout_bets('Place', placers, place_pot)
    payout_bets('Show', showers, show_pot)

    ## find all other bets and mark as Losing Bet
    losers = self.bets.where(:status => 'Pending')
    losers.update_all(:status => 'Losing Bet')
    self.status = 'Paid Out'
    self.save
  end

  def payout_bets(bet_type, horses, pot)
    logger.debug "##################  Paying out #{bet_type}"
 
    horses.each do |horse|
      card_id = self.card_id
      logger.debug "#{bet_type} is #{horse.name}"
      horse_total_bets = horse.total_bets
      logger.debug "#{bet_type} total bets = #{pot}\n"
      next if pot == 0
      #horse_odds = total_pot / winner_total_bets
      horse_total_bets = horse.total_bets(bet_type).to_f
      next if  horse_total_bets == 0
      floated_odds = pot.to_f / horse.total_bets(bet_type).to_f
      horse_odds = (floated_odds * 20).round.to_f/20
      logger.debug "odds = #{horse_odds}\n"
      next if horse_odds == 0
      #payoff_odds = winner_odds / winners_size
      #logger.debug "payoff_odds = #{payoff_odds}\n"
      horse.bets.where(:status => 'Pending').each do |bet|
        bettor = bet.user
        bet_amount = bet.amount
        logger.debug "horse bet amount: #{bet_amount}\n"
        #horse = bet.horse
        bet_payoff = bet_amount.to_f * horse_odds
        logger.debug "#{bet_type} bet payoff: #{bet_payoff}\n"
        # create credit for horse_payoff
        Credit.create( :user_id => bet.user_id,
                   :meet_id => bet.meet_id,
                   :amount => bet_payoff,
                   :credit_type => bet_type,
                   :card_id => card_id,
                   :description => "Winnings: #{self.name} on #{bet_type} on #{horse.name}",
                   :track_id => self.track_id
                 
                 )
        bet.status = 'Paid Out'
        bet.save
        bettor.update_card_ranking(horse.race.card, bet_payoff)
      end
    end

  end
end
