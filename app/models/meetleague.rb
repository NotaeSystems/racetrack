class Meetleague < ActiveRecord::Base
  belongs_to :league
  belongs_to :meet
  has_one :track, :through => :meet
  attr_accessible :league_id, :meet_id
end
