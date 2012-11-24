class Track < ActiveRecord::Base
  has_many :meets, :dependent => :destroy
  scope :active, where(:open => true)
  belongs_to :owner, :class_name => "User"
  attr_accessible :description, :name, :open, :owner_id, :public
end
