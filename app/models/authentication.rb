class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :token, :uid, :user_id
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of_uid, :scope => :provider
end
