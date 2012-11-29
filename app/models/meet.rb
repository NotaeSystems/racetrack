class Meet < ActiveRecord::Base
  has_many :cards
  belongs_to :track
  has_many :rankings
  has_many :comments
  has_many :meetleagues
  has_many :leagues, :through => :meetleagues

  scope :active, where(:open => true)
  attr_accessible :completed, :completed_date, :description, :name, :open, :track_id, :status, :initial_credits

  def refresh_credits(user)

   Credit.create( :user_id => user.id,
                   :meet_id => self.id,
                   :amount => self.initial_credits,
                   :credit_type => 'Free',
                   :description => 'Refreshed credits'
                 )
   user.update_ranking(self.id, 100)

  end
end
