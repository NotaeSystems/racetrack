class ActionPusher < AbstractController::Base
  include AbstractController::Rendering
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include Rails.application.routes.url_helpers
  helper ApplicationHelper
  self.view_paths = "app/views"

  class Pushable
    def initialize(channel, event, pushtext)
      @channel = channel
      @pushtext = pushtext
      @event = event
    end

    def push
      #PusherChannel.send_message(@channel, @channel, @pushtext)
       Pusher.trigger(@channel, @event, @pushtext )
      #Pusher[@channel].trigger('race_channel', {:message => 'hello world'})
    end
  end
end
