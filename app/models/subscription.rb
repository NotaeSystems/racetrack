class Subscription < ActiveRecord::Base
  attr_accessible :amount, :begin_date, :description, :expires, :name, :period, :email, :plan_id, :site_id, :status, :stripe_customer_token, :user_id

 attr_accessor :stripe_card_token
 belongs_to :plan
 belongs_to :user
 belongs_to :site

  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(description:email, plan: self.plan.name, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  end
end
