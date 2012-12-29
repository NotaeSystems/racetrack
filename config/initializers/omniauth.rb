Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = '/auth'
  end

  # The following is for facebook'
 # provider :facebook, 	'345611455538203', '28c172fef0d3495d040847204bdf68d4', {:scope =>  'read_stream, publish_stream'}
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :facebook,:setup => true
  provider :stripe_connect, ENV['STRIPE_CONNECT_CLIENT_ID'], ENV['STRIPE_SECRET']
  # If you want to also configure for additional login services, they would be configured here.
end
