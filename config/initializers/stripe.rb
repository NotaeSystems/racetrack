Rails.configuration.stripe = {
  :publishable_key => 'pk_X12xwEJZY0KEBY4fHNFXySIyO648F',
  :secret_key      => '1TEXP49cVF7uLLKJX0c1R506jwOKItQD'
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
