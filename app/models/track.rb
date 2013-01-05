class Track < ActiveRecord::Base

  acts_as_taggable
  has_many :meets, :dependent => :destroy
  has_many :cards, :dependent => :destroy
  has_many :races, :dependent => :destroy
  has_many :horses, :dependent => :destroy
  has_many :comments
  has_many :trackusers,  :dependent => :destroy
  has_many :trackleagues, :dependent => :destroy
  has_many :leagues, :through => :trackleagues
  has_many :transactions,  :dependent => :destroy
  has_many :rankings,  :dependent => :destroy

  belongs_to :site
  #scope :active, where(:open => true)
  scope :active, where(:status => 'Open')
  scope :closed, where(:status => 'Closed')
  scope :pending, where(:status => 'Pending')
  belongs_to :owner, :class_name => "User"
  attr_accessible :description, :name, :open, :owner_id, :public, :status, :track_alias,
                   :meet_alias, :card_alias, :race_alias, :horse_alias, :credit_alias, :member_alias, 
                   :bet_alias, :tag_list, :membership, :site_id, :level
  
  def to_param
    "#{id}-#{name}".parameterize
  end

  def quit(user)
    trackuser = Trackuser.where(:user_id => user.id, :track_id => self.id).first
    unless trackuser.blank?
      trackuser.status = 'Removed'
      trackuser.save
    end
  end

  def join(user, status)
    trackuser = Trackuser.find_or_create_by_user_id_and_track_id(:user_id =>user.id, :track_id =>self.id, :role => 'Handicapper', :allow_comments => false, :nickname => user.name, :status => status)
    trackuser.status = status
    trackuser.save

  end
end
