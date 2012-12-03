class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  has_many :credits
  has_many :authentications, :dependent => :delete_all
  belongs_to :meet
  has_many :comments
  has_many :trackusers
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :time_zone, :status

  def password_required?
    super && encrypted_password?

  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end



  def apply_omniauth(auth)
    # In previous omniauth, 'user_info' was used in place of 'raw_info'
    self.email = auth['extra']['raw_info']['email']
    # Again, saving token is optional. If you haven't created the column in authentications table, this will fail
    authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
  end

  def is_track_owner?(track)
    return false if track.nil?
    return true if self.has_role? :admin
    return true if track.owner_id == self.id
    
  end

  def meet_balance(meet)
   self.credits.where("meet_id = ?", meet.id).sum(:amount)

  end

  def card_balance(card)
   self.credits.where("card_id = ?", card.id).sum(:amount)

  end
  
  def update_ranking(meet_id, amount)
   ranking = Ranking.where("user_id = ? and meet_id = ?",self.id, meet_id).first
   if ranking
     if ranking.amount.nil?
       ranking.amount = 0
     end
     ranking.amount = ranking.amount + amount
     ranking.save
   else
     ranking = Ranking.new
     ranking.user_id = self.id
     ranking.meet_id = meet_id
     ranking.amount =  amount
     ranking.save
   end
  end

  def update_card_ranking(card, amount)
   ranking = Ranking.where("user_id = ? and meet_id = ? and card_id = ?",self.id, card.meet_id, card.id).first
   if ranking
     ranking.amount += amount
     ranking.save
   else
     ranking = Ranking.new
     ranking.user_id = self.id
     ranking.meet_id = card.meet_id
     ranking.card_id = card.id
     ranking.amount =  amount
     ranking.save
   end
  end
end
