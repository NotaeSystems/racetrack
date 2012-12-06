class HomeController < ApplicationController
  def index
    @tracks = Track.open.page(params[:page]).per_page(30).order('name')
    @cards = Card.where("status = 'Open' ").page(params[:page]).per_page(30).order('name')

  end


end
