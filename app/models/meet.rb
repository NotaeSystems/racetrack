class Meet < ActiveRecord::Base
  scope :open, where(:open => true)
  attr_accessible :completed, :completed_date, :description, :name, :open, :track_id
end
