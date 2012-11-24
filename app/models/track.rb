class Track < ActiveRecord::Base
  has_many :meets, :dependent => :destroy
  scope :active, where(:open => true)
  attr_accessible :description, :name, :open, :owner_id, :public
end
