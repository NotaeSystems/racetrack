class ApplicationController < ActionController::Base
  protect_from_forgery
  around_filter :user_time_zone, if: :current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
  def login_required
    return true if current_user
    redirect_to root_path, :alert => "Must be logged in "
  end

  def user_is_track_manager?(track)
   return false if current_user.nil?
   return true if current_user.has_role?('admin')
   current_user.is_track_manager?(track)
  end

  protected

 # def current_user
 #   @current_user ||= User.find_by_id(session[:user_id])
 # end

 # def signed_in?
 #   !!current_user
 # end
 # helper_method  :signed_in?

  #def current_user=(user)
  #  @current_user = user
  #  session[:user_id] = user.nil? ? user : user.id
  #end

private

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
