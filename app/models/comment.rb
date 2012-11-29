class Comment < ActiveRecord::Base
  belongs_to :card
  belongs_to :user
  belongs_to :race
  belongs_to :track
  attr_accessible :body, :card_id, :meet_id, :race_id, :track_id, :user_id
end
