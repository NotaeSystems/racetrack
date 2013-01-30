##http://stackoverflow.com/questions/6318959/rails-how-to-render-a-view-partial-in-a-model
require 'action_pusher'

class CardsPusher < ActionPusher
  def initialize(card)
    @card = card
  end

  def alert_message(message)
    @message = message
    Pushable.new "card#{@card.id}", 'flash_message', render(template: 'users_pusher/alert_message')
  end

  def flash_message(message)
    @message = message
    Pushable.new "card#{@card.id}", 'flash_message', render(template: 'users_pusher/flash_message')
  end
end
