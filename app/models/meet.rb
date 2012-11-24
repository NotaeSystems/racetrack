class Meet < ActiveRecord::Base
  has_many :cards
  belongs_to :track
  scope :active, where(:open => true)
  attr_accessible :completed, :completed_date, :description, :name, :open, :track_id
end
