class HomeController < ApplicationController
  def index
    @tracks = Track.open
  end
end
