Rails.configuration.stripe = {
  :publishable_key => 'pk_test_ehw1UX8LguzylMiOfh6SAUGy',
  :secret_key      => 'sk_test_cXwORYnkk1eRDwsHZg8ULFUK'
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]

STRIPE_APPLICATION_FEE = 0.3
