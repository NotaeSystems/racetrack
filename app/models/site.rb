class Site < ActiveRecord::Base
  attr_accessible :description, :domain, :facebook_key, :facebook_secret, :initial_credits, :name, :owner_id, :sanctioned, :slug, :status, :twitter_key, :twitter_secret
end
