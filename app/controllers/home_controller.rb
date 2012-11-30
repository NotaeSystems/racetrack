class HomeController < ApplicationController
  def index
    @tracks = Track.active
    @cards = Card.where("status = 'Open' ")
  end
end
