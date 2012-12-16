class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :meet
  belongs_to :card
  belongs_to :track
  attr_accessible :amount, :credit_type, :description, :meet_id, :user_id, :status, :card_id, :track_id
end
