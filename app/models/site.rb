class Site < ActiveRecord::Base
  has_many :tracks
  has_many :cards
  has_many :leagues
  has_many :users
  has_many :subscriptions
  has_many :transactions
  belongs_to :owner, :class_name => "User"

 attr_accessible :description, :domain, :facebook_key, :rebuy_credits, :rebuy_charge, :allow_rebuys, :facebook_secret, :initial_credits, :name, :max_tracks, :owner_id, :sanctioned, :slug, :status, :twitter_key, :twitter_secret

  def self.vanity(domain,subdomains)
    site = find_by_domain(domain)
    unless subdomains.blank?
      site ||= find_by_permalink(subdomains.first)
    end
    site
  end
end
