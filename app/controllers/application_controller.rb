class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
  def login_required
    return true if current_user
    redirect_to root_path, :alert => "Must be logged in "
  end

end
