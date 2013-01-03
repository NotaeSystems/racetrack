class StripeController < ApplicationController

  def stripeconnect
 
   if params[:code]
  #  @site = Site.find(params[:state])

    #Encoding.default_external = Encoding::UTF_8
    url = 'https://connect.stripe.com/oauth/token'
    options = ":query => {:code => params[:code], :grant_type => 'authorization_code'}" 

    header = ":headers => {'Authorization' => 'Bearer sk_test_cXwORYnkk1eRDwsHZg8ULFUK'}"
    response = HTTParty.post(url, :query => {:code => params[:code], :grant_type => 'authorization_code'}, :headers => {'Authorization' => 'Bearer sk_test_cXwORYnkk1eRDwsHZg8ULFUK'})
    logger.debug response
    logger.debug response['stripe_publishable_key']
     @site.stripeconnect = response['stripe_publishable_key']
     @site.save


     redirect_to dashboard_manage_path, :notice => 'Successfully setup for Stripe Connect'
   else
     redirect_to message_path, :notice => 'Failed setup for Stripe Connect'
   end
  end

  ### handles callbacks from stripe
  def stripehook
    render :nothing => true
  end
end
