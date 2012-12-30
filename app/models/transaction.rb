class Transaction < ActiveRecord::Base
  attr_accessible :amount, :description, :name, :site_id, :track_id, :transaction_type, :user_id
end
