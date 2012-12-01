class HomeController < ApplicationController
  def index
    @tracks = Track.active
    @cards = Card.where("status = 'Open' ")
Pusher['test'].trigger('greet', {
  :greeting => "Hello there!"
})
  end
end
