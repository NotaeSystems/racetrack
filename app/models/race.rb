class Race < ActiveRecord::Base
  has_many :horses
  belongs_to :card
  has_many :bets
  has_many :winning_bets, :class_name => 'Bet'
  attr_accessible :card_id, :completed, :completed_date, :description, :name, :open, :post_time, :start_betting_time

  def total_bets
    self.bets.sum(:amount)  
  end

  
  def close
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
      winner.bets.each do |bet|
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
                   :description => "Winnings: #{self.name}"
                 )
      end
    end
    self.open = false
    self.save
  end
end
