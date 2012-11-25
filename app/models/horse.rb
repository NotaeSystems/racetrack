class Horse < ActiveRecord::Base
  belongs_to :race
  has_many :bets
  attr_accessible :description, :finish, :name, :race_id

  def total_bets
    self.bets.sum(:amount)  
  end
 
  
  def odds
    return 0 if self.total_bets == 0
    self.race.total_bets / self.total_bets
  end
end
