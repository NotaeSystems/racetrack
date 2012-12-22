class UsersController < ApplicationController
  before_filter :login_required_filter, :except => [:new, :create]
  before_filter :user_is_admin_filter?, :only => [:login_as, :add_role, :remove_role, :index, :destroy]
  before_filter :check_for_user, :only => [:edit, :update]

  def add_role
   user_id = params[:user_id]
   role = params[:role_id]

   user = User.where(:id => user_id).first
   user.add_role :admin
   redirect_to users_path
  end

  def remove_role
   user_id = params[:user_id]
   role = params[:role_id]

   user = User.where(:id => user_id).first
   user.remove_role :admin
   redirect_to users_path
  end

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

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to myaccount_path(@user), notice: "Thank you for registering"
    else
      render "new"
    end
  end



  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
    if current_user == @user.id || user_is_admin?
    
    else

    end
  end  

  def update
   # authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if current_user == @user.id || user_is_admin?
      @user.name = params[:user][:name]
      @user.email = params[:user][:email]
      unless params[:user][:password].blank?
        @user.password = params[:user][:password]
        @user.password_confirmation = params[:user][:password_confirmation]
      end
      @user.time_zone = params[:user][:time_zone]
      @user.encrypt_password
      # if @user.update_attributes(params[:user], :as => :admin)
      if @user.save
        redirect_to myaccount_path, :notice => "User updated."
      else
        redirect_to myaccount_path, :alert => "Unable to update user."
      end
    else
        redirect_to message_path, :error => "Unable to update user."
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
  private

  def check_for_user
    @user = User.find(params[:id])
    return true if current_user.id == @user.id || user_is_admin?
    flash[:error] = "Not Authorized"
    redirect_to(message_path)
  end
end
