class Bet < ActiveRecord::Base
  scope :win
  belongs_to :user
  belongs_to :horse
  belongs_to :meet
  belongs_to :card
  belongs_to :track
  belongs_to :race
  
  belongs_to :win, :class_name => "Horse"
  belongs_to :place, :class_name => "Horse"
  belongs_to :show, :class_name => "Horse"
  belongs_to :fourth, :class_name => "Horse"

  attr_accessible :amount,:bet_type, :horse_id, :meet_id, :user_id, :race_id, :status, :track_id, 
                   :win_id, :place_id, :show_id, :fourth_id, :card_id
  validates_presence_of :amount, :bet_type
end
