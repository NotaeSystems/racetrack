class Horse < ActiveRecord::Base
  belongs_to :race
  has_many :bets
  attr_accessible :description, :finish, :name, :race_id, :status

  def total_bets
    self.bets.sum(:amount)  
  end
 
  
  def odds
    return 0 if self.total_bets == 0
    floated_odds = self.race.total_bets.to_f / self.total_bets.to_f
    odds = (floated_odds * 20).round.to_f/20
  end
end
