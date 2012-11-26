class Credit < ActiveRecord::Base
  attr_accessible :amount, :credit_type, :description, :meet_id, :user_id, :status
end
