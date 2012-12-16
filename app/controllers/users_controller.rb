class UsersController < ApplicationController
  before_filter :authenticate_user!


  def login_as
    @user = User.find(params[:user_id])
    sign_in_and_redirect(:user, @user)
  end

  def myachievements
       #   current_user.add_achievement('Neophyte')
    @achievementusers = Achievementuser.where(:user_id => current_user.id)
  end

  def myleagues
    @leagueusers = Leagueuser.where("user_id = ?", current_user.id)

  end

  def mytracks
   
   @trackusers = Trackuser.member.where("user_id = ?", current_user.id)
  end

  def myaccount


  end

  def mybets
    if params[:user]
      @title = 'All My Bets'
      @bets = Bet.where(:user_id => current_user.id ).order('created_at DESC').page(params[:page]).per_page(30)
    elsif params[:card]
       @card = Card.where(:id => params[:card]).first
       @track = @card.track
       @title = "All My #{@track.card_alias} Bets"
       @bets = Bet.where(:card_id =>params[:card],:user_id => current_user.id ).order('created_at DESC').page(params[:page]).per_page(30)
    elsif params[:track]
       @title = 'All My Track Bets'
       @bets = Bet.where(:track_id =>params[:track],:user_id => current_user.id ).order('created_at DESC').page(params[:page]).per_page(30)
    elsif params[:meet]
       @title = 'All My Meet Bets'
       @bets = Bet.where(:meet_id =>params[:meet],:user_id => current_user.id ).order('created_at DESC').page(params[:page]).per_page(30)
    elsif params[:race]
       @race = Race.where(:id => params[:race]).first
       @track = @race.track
       @title = "All My #{@track.race_alias} Bets"
       @bets = Bet.where(:race_id =>params[:race],:user_id => current_user.id ).order('created_at DESC').page(params[:page]).per_page(30)
    else
      @title = 'All My Bets'
       @bets= Bet.where(:user_id => current_user.id).order('created_at DESC').page(params[:page]).per_page(30)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bets }
    end
  end

  def mycredits
    if params[:user]
      @credits = Credit.where(:user_id => current_user.id ).order('created_at DESC').page(params[:page]).per_page(30)
    elsif params[:card]
       @credits = Credit.where(:card_id =>params[:card],:user_id => current_user.id ).order('created_at DESC').page(params[:page]).per_page(30)
    elsif params[:track]
       @credits = Credit.where(:track_id =>params[:track],:user_id => current_user.id ).order('created_at DESC').page(params[:page]).per_page(30)
    elsif params[:meet]
       @credits = Credit.where(:meet_id =>params[:meet],:user_id => current_user.id ).order('created_at DESC').page(params[:page]).per_page(30)
    else
       @credits= Credit.where(:user_id => current_user.id).order('created_at DESC').page(params[:page]).per_page(30)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bets }
    end
  end

  def my_owned_tracks
   @tracks = Track.where(:owner_id => current_user.id)
  end

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @search = User.page(params[:page]).per_page(30).order('email').search(params[:q])
    @users = @search.result

    @count = User.count
  #  @users = User.page(params[:page]).per_page(30).order('email')

  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])

  end  

  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.time_zone = params[:user][:time_zone]

   # if @user.update_attributes(params[:user], :as => :admin)
     if @user.save
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
    
  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end
end
