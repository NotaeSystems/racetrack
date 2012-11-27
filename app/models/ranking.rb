class Ranking < ActiveRecord::Base
belongs_to :user
belongs_to :meet

  attr_accessible :amount, :meet_id, :rank, :user_id
end
