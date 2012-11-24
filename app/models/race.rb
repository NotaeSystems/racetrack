class Race < ActiveRecord::Base
  has_many :horses
  belongs_to :card
  attr_accessible :card_id, :completed, :completed_date, :description, :name, :open, :post_time, :start_betting_time
end
