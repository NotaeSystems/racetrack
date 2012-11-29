class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :meet
  attr_accessible :amount, :credit_type, :description, :meet_id, :user_id, :status, :card_id
end
