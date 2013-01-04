class Ranking < ActiveRecord::Base
belongs_to :user
belongs_to :meet
belongs_to :card
  attr_accessible :amount, :meet_id, :rank, :user_id, :card_id, :level, :race_id, :league_id
end
