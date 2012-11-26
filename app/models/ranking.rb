class Ranking < ActiveRecord::Base
  attr_accessible :amount, :meet_id, :rank, :user_id
end
