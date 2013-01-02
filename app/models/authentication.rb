class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :token, :uid, :user_id
#  validates_presence_of :user_id, :uid, :provider
 # validates_uniqueness_of_uid, :scope => :provider

  def self.find_with_omniauth(auth,site_id)
    find_by_provider_and_uid_and_site_id(auth['provider'], auth['uid'], site_id)
  end

  def self.create_with_omniauth(auth, site_id)
    create(uid: auth['uid'], provider: auth['provider'], site_id: site_id)
  end

  def create_new_user(auth, site_id)
     new_user = User.new

     #new_user.apply_omniauth(auth)
     self.token = auth['credentials']['token']
     self.site_id = site_id
     self.save
      new_user.email = auth['extra']['raw_info']['email']
      if new_user.email.blank?
        new_user.email = "#{auth['provider']}_#{auth['uid']}@fantasyoddsmaker.com"
      end
     new_user.name = auth["info"]["name"]
     new_user.avatar = auth["info"]["image"]
     new_user.status = 'Member'
     new_user.amount = 0
     new_user.time_zone = 'Central Time (US & Canada)'
     new_user.site_id = site_id
     if new_user.save(:validate => false)
       new_user.add_role :user
       return new_user
     end

  end


end
