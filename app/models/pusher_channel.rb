class PusherChannel < ActiveRecord::Base
    require 'pusher'
  # attr_accessible :title, :body


 def self.send_message(channel,id, message)

   Pusher[channel].trigger(id, {:greeting => message})

 end
end
