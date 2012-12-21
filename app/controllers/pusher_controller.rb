class PusherController < ApplicationController
  before_filter :login_required_filter

 def send_message
   @channel = params[:channel]
   @card = Card.find(params[:card_id])

   id =params[:id]

   @message = params[:message]

   PusherChannel.send_message(@channel, @channel, @message)
   #Pusher['test_channel'].trigger('greet', {:greeting => "Hello there!"})
   flash.notice = "Message: #{@message}. Sent OK"
   redirect_to card_path(@card)
 end

 def message
   @channel = params[:channel]
   @card_id = params[:card_id]
   
 end
end
