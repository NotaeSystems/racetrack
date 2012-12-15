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
  validates_presence_of     :name   

  def add_achievement(achievement_name, provider = nil)
   achievement = Achievement.where(:name => achievement_name, :status => 'Site').first

   Achievementuser.find_or_create_by_user_id_and_achievement_id(:user_id => self.id,
                           :achievement_id => achievement.id
                           )
   if provider = 'facebook'
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
    leagueuser = Leagueuser.where(:user_id => self.id, :track_id => track.id, :status => 'Manager').first
    return true unless leagueuser.blank?
    false
    
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
