class Race < ActiveRecord::Base
  has_many :horses
  belongs_to :card
  has_many :bets
  attr_accessible :card_id, :completed, :completed_date, :description, :name, :open, :post_time, :start_betting_time

  def total_bets
    self.bets.sum(:amount)  
  end
end
