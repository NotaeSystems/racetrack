class Bet < ActiveRecord::Base
  attr_accessible :amount, :bet_type, :horse_id, :meet_id, :user_id, :race_id
end
