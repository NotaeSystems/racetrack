class Track < ActiveRecord::Base
  has_many :meets, :dependent => :destroy
  has_many :comments
  has_many :trackusers
  has_many :trackleagues
  has_many :leagues, :through => :trackleagues
  scope :active, where(:open => true)
  scope :open, where(:status => 'Open')
  scope :closed, where(:status => 'Closed')
  scope :pending, where(:status => 'Pending')
  belongs_to :owner, :class_name => "User"
  attr_accessible :description, :name, :open, :owner_id, :public, :status, :track_alias, :meet_alias, :card_alias, :race_alias, :horse_alias
end
