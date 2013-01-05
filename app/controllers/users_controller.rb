class UsersController < ApplicationController
  before_filter :login_required_filter, :except => [:new, :create]
  before_filter :user_is_admin_filter?, :only => [ :add_role, :remove_role, :index, :destroy]
  before_filter :return_as_admin_filter, :only => [:return_as_admin]
  before_filter :check_for_user, :only => [:edit, :update]


  def credits
    @user = User.find(params[:id])
   @credits = @user.credits.page(params[:page]).per_page(30)
   render 'mycredits'
  end

   def rankings
    @user = User.find(params[:id])
    @rankings = @user.rankings.page(params[:page]).per_page(30)
  end

  def transactions
    @user = User.find(params[:id])
    @credits = @user.credits.page(params[:page]).per_page(30)
  end

  def tracks
    @user = User.find(params[:id])
   @trackusers = Trackuser.member.where("user_id = ?", @user.id)
   render 'mytracks'
  end

  def bets
    @user = User.find(params[:id])
    @bets = @user.bets.page(params[:page]).per_page(30)
   render 'mybets'
  end

  def leagues
    @user = User.find(params[:id])
    @leagueusers = Leagueuser.where("user_id = ?", @user.id)
   render 'myleagues'
  end

  def borrow_credits
    if current_user.credits_balance > 0
      redirect_to myaccount_path, :alert => "You can borrow additional credits only if you have a zero balance"
    else
      message = current_user.borrow_credits(@site.initial_credits)
      source = params[:race_id]
    
      if params[:race_id]
        race = Race.find(params[:race_id])
        redirect_to race_path(race), :alert => message
      else
        redirect_to myaccount_path, :alert => message
      end
    end
  end

  def rebuy_credits
    if current_user.credits_balance > 100
      redirect_to myaccount_path, :alert => "You can rebuy additional credits only if you have less than 100 credits"
    else
      number =  @site.rebuy_credits
      charge = @site.rebuy_charge
      message = current_user.rebuy_credits(number, charge)
      source = params[:race_id]
    
      if params[:race_id]
        race = Race.find(params[:race_id])
        redirect_to race_path(race), :alert => message
      else
        redirect_to myaccount_path, :alert => message
      end
    end
  end

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
    return_as = current_user.id
    @user = User.find(params[:user_id])
    session[:user_id] = @user.id
    session[:return_as] = return_as
    redirect_to myaccount_path
  end

  def return_as_admin
    @return_user = User.find(params[:user_id])
    session[:user_id] = @return_user.id
    session[:return_as] = nil
    redirect_to myaccount_path
  end

  def myachievements
    @user = current_user
       #   current_user.add_achievement('Neophyte')
    @achievementusers = Achievementuser.where(:user_id => @user.id)
  end

  def myleagues
    @user = current_user
    @leagueusers = Leagueuser.where("user_id = ?", @user.id)

  end

  def mytracks
   @user = current_user
   @trackusers = Trackuser.member.where("user_id = ?", @user.id)
  end

  def myaccount
    @only_track = nil
    if @site.tracks.active.count == 1
      @only_track = @site.tracks.active.first
    end
    @credits_balance = current_user.credits_balance

  end

  def mybets
    if params[:user]
      @user = current_user
      @title = 'All My Bets'
      @bets = Bet.where(:user_id => @user.id ).order('created_at DESC').page(params[:page]).per_page(30)
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
    elsif params[:site]
       @credits = Credit.where(:site_id =>params[:site],:user_id => current_user.id ).order('created_at DESC').page(params[:page]).per_page(30)
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
    @user.site_id = @site.id
    @user.status = 'Member'
    @user.amount = 0
    if @user.save

      session[:user_id] = @user.id
      current_user.award_initial_credits(@site.initial_credits)
      current_user.add_achievement('Neophyte', nil)
      redirect_to myaccount_path(@user), notice: "Thank you for registering. You have been awarded #{@site.initial_credits} Free Credits. You are now ready to start handicapping."
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
    if current_user.id == @user.id || user_is_admin?
      @user.name = params[:user][:name]
      @user.email = params[:user][:email]
      @user.site_id = params[:user][:site_id]
      unless params[:user][:password].blank?
        @user.password = params[:user][:password]
        @user.password_confirmation = params[:user][:password_confirmation]
      end
    if user_is_admin?
        @user.amount = params[:user][:amount]
        @user.status = params[:user][:status]
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
        redirect_to message_path, :alert => "Unable to update user. Permissions Error."
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

  def return_as_admin_filter
      return_to = session[:return_to]
      return true if return_to == params[:user_id]
      redirect_to message_path, :notice => "Not Authorized."
  end

  def check_for_user
    @user = User.find(params[:id])
    return true if current_user.id == @user.id || user_is_admin?
    flash[:error] = "Not Authorized"
    redirect_to(message_path)
  end
end
