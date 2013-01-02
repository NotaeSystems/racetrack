class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :site

  attr_accessible :amount, :description, :name, :site_id, :track_id, :transaction_type, :user_id, :stripe_card_token,:level
 attr_accessor :stripe_card_token
  def save_with_payment
    if valid?
      user = self.user
      ## if the current user has already provided a credit card and we have a stripe customer id then move on
      unless user.stripe_customer_id
        customer = Stripe::Customer.create(description: 'Recharged Bank', card: stripe_card_token)
        user = self.user
        user.stripe_customer_id = customer.id
        user.save
        save!
      end
      ## if the current site has signed up as a stripe connect customer then we will have a stripeconnect id
      if self.site.stripeconnect.blank?
        ## the current site is not a stripe connect 
        charge = Stripe::Charge.create(
          :amount => self.amount, # $15.00 this time
          :currency => "usd",
          :customer => user.stripe_customer_id
        )
      else
        ## the current site is a stripe connect so we charge on their behalf and collect an application fee
        application_fee = amount.to_float * STRIPE_APPLICATION_FEE
        application_fee = application_fee.round
        charge = Stripe::Charge.create(
          {
            :amount => self.amount, # amount in cents
            :currency => "usd",
            :customer => user.stripe_customer_id,
            :description => "Recharge",
            :application_fee =>  application_fee # amount in cents
          },
          @site.stripeconnect # user's access token from the Stripe Connect flow
         )
      end
    end
    logger.debug charge
    self.description = "Recharge-#{self.amount}"
    self.transaction_code = charge.id
    self.payment_servicer = 'Stripe'
    self.save
    rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false

  end
end
