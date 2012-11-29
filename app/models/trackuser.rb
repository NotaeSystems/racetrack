class Trackuser < ActiveRecord::Base
  belongs_to :user
  belongs_to :track
  attr_accessible :allow_comments, :nickname, :role, :track_id, :user_id
end
