class Site < ActiveRecord::Base
  has_many :tracks
  has_many :cards
  has_many :leagues

  attr_accessible :description, :domain, :facebook_key, :facebook_secret, :initial_credits, :name, :owner_id, :sanctioned, :slug, :status, :twitter_key, :twitter_secret

  def self.vanity(domain,subdomains)
    site = find_by_domain(domain)
    unless subdomains.blank?
      site ||= find_by_permalink(subdomains.first)
    end
    site
  end
end
