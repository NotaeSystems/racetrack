class Track < ActiveRecord::Base
  scope :open, where(:open => true)
  attr_accessible :description, :name, :open, :owner_id, :public
end
