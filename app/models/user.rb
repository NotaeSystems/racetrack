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
  has_many :transactions, :dependent => :delete_all
  has_many :subscriptions, :dependent => :delete_all
  has_many :comments, :dependent => :delete_all
  has_many :trackusers, :dependent => :delete_all
  has_many :leagueusers, :dependent => :delete_all
  has_many :achievementusers, :dependent => :delete_all
  has_many :rankings, :dependent => :delete_all
  has_many :leagues, :through => :leagueusers
  belongs_to :site

  #devise :database_authenticatable, :registerable, 
  #       :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :password, :password_confirmation

  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :time_zone, :status, :site_id
  validates_presence_of     :name   


  def transactions_balance
    Transaction.where(:user_id => self.id).sum(:amount)

  end

  def award_initial_credits(amount)
    Credit.create( :user_id => self.id,
                   :amount => amount,
                   :description => 'Initial Credits',
                   :site_id => self.site_id, 
                   :level => 'White'
                 )
  end

  def daily_login_bonus(amount)
    logger.info 'inside of daily_login_bonus'
    if self.created_at < 24.hours.ago
       logger.info 'user created more than 24 hours ago'
       bonus_credits = Credit.where("user_id = ? and credit_type IN ('Daily Bonus') and created_at > ?",self.id, Time.now - 24.hours)
      if bonus_credits.blank?
        logger.info 'No daily bonus in last 24 hours'
        Credit.create( :user_id => self.id,
                   :amount => amount,
                   :credit_type => 'Daily Bonus',
                   :description => 'Daily Bonus',
                   :site_id => self.site_id, 
                   :level => 'White'
                 )
        return amount
      end 
    else
      logger.info 'user created less than 24 hours ago'
    end
   return 0
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
                   :site_id => self.site_id,
                   :level => 'White'
                 )
    return "You have borrowed #{amount} credits."
  end

  def recharge_account
    

  end

  def rebuy_credits(number, charge)
    ## see if bettor is member of this track
       
       ## see if bettor has been given initial card credits or borrowed in last last 24 hours
   #    initial_credits = Credit.where("user_id = ? and credit_type IN ('Initial', 'Borrowed') and created_at > ?",self.id, Time.now - 24.hours)
  
   # return "Sorry, you have rebought credits within past 24 hours" unless initial_credits.blank?
    #logger.info "initial or borrowed credits ion last 24 hours are nil now creating borrowed credits"
    ## TODO check for source of credits later may be from meet
    logger.info "Refreshing credits- #{amount} credits\n"
    Credit.create( :user_id => self.id,
                   :amount => number,
                   :description => 'Rebuy credits',
                   :credit_type => 'Rebuy', 
                   :site_id => self.site_id,
                   :level => 'Green'
                 )
    ### Put money in bank
    Transaction.create( :user_id => self.id,
                   :amount => -charge,
                   :description => "Rebuy #{number} credits",
                   :transaction_type => 'Rebuy', 
                   :site_id => self.site_id
                 )

    return "You have bought #{number} credits for $#{charge/100}."
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.authenticate(email, password, site)
    user = find_by_email_and_site_id(email, site)
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

  def charge_stripe(amount)
    Stripe::Charge.create(
      :amount => amount, 
      :currency => "usd",
      :customer => self.stripe_customer_id
    )
  end

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

  def white_credits_balance

    borrowed =  self.credits.where("level = 'White'").sum(:amount)
  end

  def red_credits_balance

    borrowed =  self.credits.where("level = 'Red'").sum(:amount)
  end

  def green_credits_balance

    borrowed =  self.credits.where("level = 'Green'").sum(:amount)
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
     ranking.amount += amount.to_i
     ranking.save
   else
     ranking = Ranking.new
     ranking.user_id = self.id
     ranking.meet_id = card.meet_id
     ranking.card_id = card.id
     ranking.amount =  amount
     ranking.save
   end
    ## update user amount #############################
    self.amount = 0 if self.amount.nil?
    self.amount += amount.to_i
    self.save
    ###################################################

    ### update leagueusers ############################
    ## find all the leagues user is member of
    myleagues_ids = self.leagues.pluck('leagues.id')
    ##find all the league meets
    meetleagues = Meetleague.where(:meet_id => card.meet.id, :league_id => myleagues_ids)
    ### update the leagueuser credits field
    meetleagues.each do |meet|
      leagueuser = Leagueuser.where(:league_id => meet.league_id, :user_id => self.id).first
      leagueuser.amount = 0 if leagueuser.amount.nil?
      leagueuser.amount += amount
      leagueuser.save
    end
    ####################################################

  end


  def update_race_ranking(race, amount, level)
   logger.debug "inside update_race_rankings race :#{race.name} amount = #{amount} level: #{level}"
   card = race.card
   meet = race.meet
   track = race.track
   logger.debug "card = #{card.name},  meet = #{meet.name}, track = #{track.name}"
   ## set ranking record for race
   ranking = Ranking.where("user_id = ? and race_id = ?",self.id, race.id).first
   if ranking
     ranking.amount += amount.to_i
     ranking.save
   else
     ranking = Ranking.new
     ranking.user_id = self.id
     ranking.race_id = race.id
     ranking.amount =  amount
     ranking.level =  level
     ranking.save
   end
   ## set ranking record for card
   ranking = Ranking.where("user_id = ? and card_id = ?",self.id, card.id).first
   if ranking
     ranking.amount += amount.to_i
     ranking.save
   else
     ranking = Ranking.new
     ranking.user_id = self.id
     ranking.card_id = card.id
     ranking.amount =  amount
     ranking.level =  level
     ranking.save
   end
   ## set ranking record for meet
   ranking = Ranking.where("user_id = ? and meet_id = ?",self.id, meet.id).first
   if ranking
     ranking.amount += amount.to_i
     ranking.save
   else
     ranking = Ranking.new
     ranking.user_id = self.id
     ranking.meet_id = meet.id
     ranking.amount =  amount
     ranking.level =  level
     ranking.save
   end

   ## set ranking record for track
   ranking = Ranking.where("user_id = ? and track_id = ?",self.id, track.id).first
   if ranking
     ranking.amount += amount.to_i
     ranking.save
   else
     ranking = Ranking.new
     ranking.user_id = self.id
     ranking.track_id = track.id
     ranking.amount =  amount
     ranking.level =  level
     ranking.save
   end

   ## set ranking record for site
   ranking = Ranking.where("user_id = ? and site_id = ?",self.id, site.id).first
   if ranking
     ranking.amount += amount.to_i
     ranking.save
   else
     ranking = Ranking.new
     ranking.user_id = self.id
     ranking.site_id = site.id
     ranking.amount =  amount
     ranking.level =  level
     ranking.save
   end

    ## update user amount #############################
    self.amount = 0 if self.amount.nil?
    self.amount += amount.to_i
    self.save
    ###################################################

    ### update leagueusers ############################
    ## find all the leagues user is member of
    myleagues_ids = self.leagues.pluck('leagues.id')
    logger.info "myleagues_id = #{myleagues_ids}"
    ##find all the league meets
    meetleagues = Meetleague.where(:meet_id => meet.id, :league_id => myleagues_ids)
    ### update the leagueuser credits field
    meetleagues.each do |meet_league|
      leagueuser = Leagueuser.where(:league_id => meet_league.league_id, :user_id => self.id).first
      logger.info "league_user = #{leagueuser.user.name}"
      leagueuser.amount = 0 if leagueuser.amount.nil?
      leagueuser.amount += amount
      leagueuser.save
    end

    ### update the league meet rankings
    meetleagues.each do |meet_league|
    logger.info "myleagues_id = #{myleagues_ids}"
      ranking = Ranking.where("user_id = ? and meet_id = ?",self.id, race.meet.id).first
      if ranking
        logger.info "existing ranking = #{ranking.id}"
        ranking.amount += amount.to_i
        ranking.save
      else
        ranking = Ranking.new
        logger.info "creating new meet league ranking"
        ranking.user_id = self.id
        ranking.meet_id = meet.id
        ranking.league_id = meet_league.league_id
        ranking.amount =  amount
        ranking.level =  level
        ranking.save
      end
    end
   ### update the league rankings
    meetleagues.each do |meet_league|
      ranking = Ranking.where("user_id = ? and league_id = ?",self.id, race.meet.id, race.meet_id).first
      if ranking
        ranking.amount += amount.to_i
        ranking.save
      else
        ranking = Ranking.new
        ranking.user_id = self.id
        ranking.meet_id = meet.id
        ranking.league_id = meet_league.league_id
        ranking.amount =  amount
        ranking.level =  level
        ranking.save
      end

    end
    ####################################################

  end
end
