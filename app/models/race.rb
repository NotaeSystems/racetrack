class Race < ActiveRecord::Base
  has_many :horses, :dependent => :destroy
  belongs_to :card
  belongs_to :track
  has_many :bets
  has_many :winning_bets, :class_name => 'Bet'
  has_many :comments   
  attr_accessible :card_id, :completed, :completed_date, :description, :name, :open, :post_time, 
                  :start_betting_time, :status, :track_id


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


  def total_bets
    self.bets.sum(:amount)  
  end

  
  def payout
    # find winners-allow for ties
    winners = self.horses.where("finish = 1")
    winners_size = winners.size
    total_pot = self.total_bets
    logger.debug "Closing odds:  winners_size: #{winners_size} total_pot = #{total_pot}\n"
    winners.each do |winner|
      logger.debug "Winner is #{winner.name}"
      winner_total_bets = winner.total_bets
      logger.debug "winner total bets = #{winner_total_bets}\n"
      next if winner_total_bets == 0
      #winner_odds = total_pot / winner_total_bets
      floated_odds = total_pot.to_f / winner.total_bets.to_f
      winner_odds = (floated_odds * 20).round.to_f/20
      logger.debug "winner_odds = #{winner_odds}\n"
      next if winner_odds == 0
      #payoff_odds = winner_odds / winners_size
      #logger.debug "payoff_odds = #{payoff_odds}\n"
      winner.bets.where(:status => 'Pending').each do |bet|
        bettor = bet.user
        bet_amount = bet.amount
        logger.debug "horse bet amount: #{bet_amount}\n"
        horse = bet.horse
        bet_payoff = bet_amount.to_f * winner_odds
        logger.debug "bet payoff: #{bet_payoff}\n"
        # create credit for horse_payoff
        Credit.create( :user_id => bet.user_id,
                   :meet_id => bet.meet_id,
                   :amount => bet_payoff,
                   :credit_type => 'Win',
                   :card_id => winner.race.card_id,
                   :description => "Winnings: #{self.name}",
                   :track_id => self.track_id
                 
                 )
        bet.status = 'Paid Out'
        bet.save
        bettor.update_card_ranking(winner.race.card, bet_payoff)
      end
    end
    ## find all other bets and mark as Losing Bet
    losers = self.bets.where(:status => 'Pending')
    losers.update_all(:status => 'Losing Bet')
    self.status = 'Paid Out'
    self.save
  end
end
