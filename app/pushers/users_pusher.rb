##http://stackoverflow.com/questions/6318959/rails-how-to-render-a-view-partial-in-a-model
require 'action_pusher'

class UsersPusher < ActionPusher
  def initialize(user)
    @user = user
  end

  def alert_message(message)

    @message = message
    Pushable.new "user#{@user.id}", 'flash_message', render(template: 'users_pusher/alert_message')
    #Pusher.trigger(channel,'race_channel','help' )
  end

  def flash_message(message)

    @message = message
    Pushable.new "user#{@user.id}", 'flash_message', render(template: 'users_pusher/flash_message')
    #Pusher.trigger(channel,'race_channel','help' )
  end
end
