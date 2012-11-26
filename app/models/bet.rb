class Bet < ActiveRecord::Base
  scope :win
  belongs_to :user
  belongs_to :horse
  belongs_to :meet
  attr_accessible :amount, :bet_type, :horse_id, :meet_id, :user_id, :race_id, :status
  validates_presence_of :amount, :bet_type
end
