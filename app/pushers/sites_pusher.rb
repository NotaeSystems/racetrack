##http://stackoverflow.com/questions/6318959/rails-how-to-render-a-view-partial-in-a-model
require 'action_pusher'

class SitesPusher < ActionPusher
  def initialize(site)
    @site = site
  end

  def alert_message(message)
    @message = message
    Pushable.new "site#{@site.id}", 'flash_message', render(template: 'users_pusher/alert_message')
  end

  def flash_message(message)
    @message = message
    Pushable.new "site#{@site.id}", 'flash_message', render(template: 'users_pusher/flash_message')
  end
end
