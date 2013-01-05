class Ranking < ActiveRecord::Base
belongs_to :user
belongs_to :meet
belongs_to :card
belongs_to :track
belongs_to :race
belongs_to :site
  attr_accessible :amount, :meet_id, :rank, :user_id, :card_id, :level, :race_id, :league_id
end
