class Track < ActiveRecord::Base

  acts_as_taggable
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
  attr_accessible :description, :name, :open, :owner_id, :public, :status, :track_alias,
                   :meet_alias, :card_alias, :race_alias, :horse_alias, :credit_alias, :member_alias, :bet_alias, :tag_list


  def quit(user)
    trackuser = Trackuser.where(:user_id => user.id, :track_id => self.id).first
    unless trackuser.blank?
      trackuser.status = 'Removed'
      trackuser.save
    end
  end

  def join(user)
    trackuser = Trackuser.find_or_create_by_user_id_and_track_id(:user_id =>user.id, :track_id =>self.id, :role => 'Handicapper', :allow_comments => false, :nickname => user.name, :status => 'Member')
    trackuser.status = 'Member'
    trackuser.save

  end
end
