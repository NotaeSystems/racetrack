class HomeController < ApplicationController
  def index
    @tracks = @site.tracks.active.page(params[:page]).per_page(30).order('name')
    @cards = @site.cards.where("status = 'Open'" ).page(params[:page]).per_page(30).order('name')

  end

  def message
   @message = params[:message]
  end
end
