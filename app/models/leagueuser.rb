class Leagueuser < ActiveRecord::Base
  belongs_to :league
  belongs_to :user
  attr_accessible :active, :league_id, :nickname, :status, :user_id
end
