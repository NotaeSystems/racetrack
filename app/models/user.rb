class User < ActiveRecord::Base
  before_save :encrypt_password


  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
 # belongs_to :meet

  has_many :credits, :dependent => :delete_all
  has_many :bets, :dependent => :delete_all
  has_many :authentications, :dependent => :delete_all

  has_many :comments, :dependent => :delete_all
  has_many :trackusers, :dependent => :delete_all
  has_many :leagueusers, :dependent => :delete_all
  has_many :achievementusers, :dependent => :delete_all
  has_many :rankings, :dependent => :delete_all

  belongs_to :site

  #devise :database_authenticatable, :registerable, 
  #       :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :password, :password_confirmation

  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :time_zone, :status, :site_id
  validates_presence_of     :name   

  def award_initial_credits(amount)
    Credit.create( :user_id => self.id,
                   :amount => amount,
                   :description => 'Initial Credits',
                   :site_id => self.site_id
                 )

  end

  def borrow_credits(amount)
    ## see if bettor is member of this track
       
       ## see if bettor has been given initial card credits or borrowed in last last 24 hours
       initial_credits = Credit.where("user_id = ? and credit_type IN ('Initial', 'Borrowed') and created_at > ?",self.id, Time.now - 24.hours)
  
    return "Sorry, you have borrowed credits within past 24 hours" unless initial_credits.blank?
    logger.info "initial or borrowed credits ion last 24 hours are nil now creating borrowed credits"
    ## TODO check for source of credits later may be from meet
    logger.info "Refreshing credits- #{amount} credits\n"
    Credit.create( :user_id => self.id,
                   :amount => amount,
                   :description => 'Borrowed credits',
                   :credit_type => 'Borrowed', 
                   :site_id => self.site_id
                 )
    return "You have borrowed #{amount} credits."
  end


  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.authenticate(email, password, site)
    user = find_by_email_and_site(email, site.id)
    if user && user.encrypted_password == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end



 # def password_digest
 #   encrypted_password
 # end

 # def has_role?(role)
 #   role = Role.where(:name => role, :resource_id => self.id).first
   # logger.info = "Role = #{role.inspect}"
 #   return true if role
 # end

  def add_achievement(achievement_name, provider = nil)
   achievement = Achievement.where(:name => achievement_name, :status => 'Site').first

   Achievementuser.find_or_create_by_user_id_and_achievement_id(:user_id => self.id,
                           :achievement_id => achievement.id
                           )
   if provider == 'facebook'
  ##TODO add achievement to Facebook achievements
        oauth = Koala::Facebook::OAuth.new(FACEBOOK_APP_ID, FACEBOOK_SECRET)
        token = oauth.get_app_access_token
        logger.debug "token = #{token}\n"
        # achievement url
        @achievement_url = "http://www.fantasyoddsmaker.com/achievements/#{achievement.id}/"
        # fb graph api url
        #user_token = self.oauth_token('facebook')
        fb_uid = self.fb_uid

        @fbcall = "https://graph.facebook.com/#{fb_uid}/achievements"

        begin

        response = RestClient.post @fbcall, :access_token => token, :achievement => @achievement_url 
        logger.debug "Response to adding achievement to Facebook = #{response}"
        rescue => e
         e.response
         logger.debug "Error assigning achievement #{achievement.name} #{e.response}"
        end
    end
  end

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
      if self.email.blank?
        self.email = "#{auth['provider']}_#{auth['uid']}@fantasyoddsmaker.com"
      end
    # Again, saving token is optional. If you haven't created the column in authentications table, this will fail
    authentications.build(:user_id => self.id, :provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
  end
  
  def oauth_token(provider)
    authentication = self.authentications.where("provider = ?", provider).last
    
    authentication.token 

  end


  def fb_uid

    authentication = self.authentications.where("provider = ?", 'facebook').last
    
    authentication.uid 

  end
  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token('facebook'))
   # block_given? ? yield(@facebook) : @facebook
   # rescue Koala::Facebook::APIError
   # logger.info e.to_s
   # nil


  end

  def twitter
    #@facebook ||= Koala::Facebook::API.new(oauth_token('facebook'))
   # block_given? ? yield(@facebook) : @facebook
   # rescue Koala::Facebook::APIError
   # logger.info e.to_s
   # nil


  end

  def is_track_owner?(track)
    return false if track.nil?
    return true if self.has_role? :admin
    return true if track.owner_id == self.id
    
  end

  def is_track_manager?(track)
    return false if track.nil?
    return true if track.owner_id == self.id
    return true if self.has_role? :admin
    trackuser = Trackuser.where(:user_id => self.id, :track_id => track.id, :status => 'Manager').first
    return true unless trackuser.blank?
    false
    
  end

  def meet_balance(meet)
   self.credits.where("meet_id = ?", meet.id).sum(:amount)

  end

  def card_balance(card)
   self.credits.where("card_id = ?", card.id).sum(:amount)

  end
  
  
  def borrowed_credits_balance

    borrowed =  self.credits.where("credit_type IN ('Borrowed', 'Rebuy')").sum(:amount)
  end

  def credits_balance
    winnings =  self.credits.sum(:amount)
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
