class Bet < ActiveRecord::Base
  scope :win
  belongs_to :user
  belongs_to :horse
  belongs_to :meet
  belongs_to :card

  attr_accessible :amount, :bet_type, :horse_id, :meet_id, :user_id, :race_id, :status, :track_id
  validates_presence_of :amount, :bet_type
end
