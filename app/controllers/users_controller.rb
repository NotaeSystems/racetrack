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
    if @user.update_attributes(params[:user], :as => :admin)
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
