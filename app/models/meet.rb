class Meet < ActiveRecord::Base
  has_many :cards
  belongs_to :track
  scope :active, where(:open => true)
  attr_accessible :completed, :completed_date, :description, :name, :open, :track_id, :status

  def refresh_credits(user)

   Credit.create( :user_id => user.id,
                   :meet_id => self.id,
                   :amount => 100,
                   :credit_type => 'Promotional',
                   :description => 'Refreshed credits'
                 )
   user.update_ranking(self.id, 100)

  end
end
