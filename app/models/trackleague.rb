class Trackleague < ActiveRecord::Base
belongs_to :league
belongs_to :track
  attr_accessible :league_id, :track_id
end
