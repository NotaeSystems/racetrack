class Achievementuser < ActiveRecord::Base
  belongs_to :user
  belongs_to :achievement
  attr_accessible :achievement_id, :meet_id, :track_id, :trackuser_id, :user_id
end
