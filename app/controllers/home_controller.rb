class HomeController < ApplicationController
  def index
    @tracks = Track.active
  end
end
