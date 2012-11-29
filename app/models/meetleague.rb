class Meetleague < ActiveRecord::Base
  belongs_to :league
  belongs_to :meet
  attr_accessible :league_id, :meet_id
end
