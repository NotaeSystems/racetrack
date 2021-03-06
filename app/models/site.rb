class Site < ActiveRecord::Base
  ActiveModel::ForbiddenAttributesProtection
  has_many :meets
  has_many :tracks, :dependent => :destroy
  has_many :cards
  has_many :races
  has_many :horses
  has_many :leagues, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :subscriptions, :dependent => :destroy
  has_many :transactions
  has_many :rankings, :dependent => :destroy
  belongs_to :owner, :class_name => "User"

  default_value_for :track_alias, 'Track' 
  default_value_for :meet_alias, 'Meet' 
  default_value_for :card_alias, 'Racing Card' 
  default_value_for :race_alias, 'Race' 
  default_value_for :horse_alias, 'Outcome' 
  default_value_for :credit_alias, 'Point' 
  default_value_for :member_alias, 'Player' 
  default_value_for :bet_alias, 'Wager' 
  default_value_for :bank_alias, 'Bank' 
  default_value_for :initial_credits, 700
  default_value_for :daily_login_bonus, 700
  default_value_for :rebuy_credits, 700
  default_value_for :rebuy_charge, 100
  default_value_for :allow_rebuys, false
  default_value_for :allow_facebook, false
  default_value_for :allow_twitter, false
  default_value_for :allow_leagues, false
  default_value_for :allow_bank, false
  default_value_for :allow_stripe, false
  default_value_for :live_push, false
  default_value_for :status, 'Open'
  default_value_for :max_tracks, 1

 attr_accessible :description, :domain,  :daily_login_bonus, :stripeconnect, :allow_bank, :level,:initial_bank, 
                 :allow_stripe, :allow_twitter, :bank_alias, :credit_alias, :member_alias, :live_push, :allow_facebook,
                 :allow_leagues, :track_alias, :meet_alias, :card_alias, :race_alias, :horse_alias, :bet_alias, 
                 :facebook_key, :rebuy_credits, :permalink, :rebuy_charge,:allow_rebuys, :facebook_secret, 
                 :initial_credits, :name, :max_tracks, :owner_id, :sanctioned, :slug,:status, :twitter_key, 
                 :twitter_secret

  def stripe_publishable_key
   return self.stripeconnect unless stripeconnect.blank?
   Rails.configuration.stripe[:publishable_key]
  end

  def self.vanity(domain,subdomains)
    site = find_by_domain(domain)
    unless subdomains.blank?
      site ||= find_by_permalink(subdomains.first)
    end
    site
  end
end
