class Achievement < ActiveRecord::Base
  attr_accessible :description, :image_url, :name, :points, :position, :rule, :status, :title, :url

  def register_facebook
        oauth = Koala::Facebook::OAuth.new(FACEBOOK_APP_ID, FACEBOOK_SECRET)
        token = oauth.get_app_access_token
        logger.debug "token = #{token}\n"
        # achievement url
        @url = "http://www.fantasyoddsmaker.com/achievements/#{self.id}"
        # fb graph api url
        @fbcall = "https://graph.facebook.com/#{FACEBOOK_APP_ID}/achievements"
        uri = URI(@fbcall)
        logger.debug "uri host #{uri.host}\n"
        res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_PEER) do |http|
            req = Net::HTTP::Post.new(uri.request_uri)
            req.set_form_data('access_token' => token, 'achievement' => @url, 'display_order' => self.position)
            logger.debug "net post = #{uri.request_uri}\n"
            response = http.request(req)
        end

  end
end
