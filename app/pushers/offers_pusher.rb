##http://stackoverflow.com/questions/6318959/rails-how-to-render-a-view-partial-in-a-model
require 'action_pusher'

class OffersPusher < ActionPusher
  def initialize(offer)
    @offer = offer
  end



  def update_offers(offer = nil)
    default_url_options[:host] = offer.gate.race.card.meet.track.site.domain

      @gate = offer.gate
      @race = @gate.race
      @card = @race.card
      @meet = @card.meet
      @track = @meet.track
      #@buy_offers = @gate.offers.where("offer_type = 'Buy' and expires > ?", Time.now).order('price')
      @buy_offers = @gate.offers.where("offer_type = 'Buy' and status = 'Pending' and expires > ? ", Time.now).order('price desc')
      @best_buy_offer =  @gate.offers.where("offer_type = 'Buy' and status = 'Pending' and expires > ?", Time.now, ).order('price desc').first


     # @sell_offers = @gate.offers.where("offer_type = 'Sell' and expires > ?", Time.now).order('price desc')
      @sell_offers = @gate.offers.where("offer_type = 'Sell' and status = 'Pending' and expires > ?", Time.now ).order('price')
      @best_sell_offer =  @gate.offers.where("offer_type = 'Sell' and status = 'Pending' and expires > ? ", Time.now  ).order('price').first

      #@contracts = @gate.contracts.where("user_id = ? and status = 'Open'", current_user.id) 
      #@balance = @gate.contracts.where("user_id = ? ", current_user.id).sum(:price)
    channel = "gate#{@gate.id}"
    if offer.offer_type == 'Sell'
      Pushable.new channel, 'offersEvent',  render(template: 'offers_pusher/buy_offers')
    else
      Pushable.new channel, 'offersEvent',  render(template: 'offers_pusher/sell_offers')
    end
    #Pusher.trigger(channel,'race_channel','help' )
  end
end
