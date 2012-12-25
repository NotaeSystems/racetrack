class ApplicationController < ActionController::Base
  protect_from_forgery
  around_filter :user_time_zone, if: :current_user
 
  before_filter :determine_site

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  


  def user_is_track_manager?(track)
   return false if track.nil?
   return false if current_user.nil?
   return true if track.owner_id == current_user.id
   return true if user_is_site_manager?
   return true if current_user.has_role? :admin
   trackuser = Trackuser.where(:user_id => current_user.id, :track_id => track.id, :status => 'Manager').first
   return true unless trackuser.blank?
   false
  end


  def user_is_league_manager?(league)
   return false if league.nil?
   return false if current_user.nil?
   return true if league.owner_id == current_user.id
   return true if user_is_site_manager?
   return true if current_user.has_role?('admin')

   leagueuser = Leagueuser.where(:user_id => current_user.id, :league_id => league.id, :status => 'Manager').first
   return true unless leagueuser.blank?
   false
  end

  protected
  def current_user
   @current_user ||= User.find_by_id(session[:user_id])
   
 end

 def signed_in?
    !!current_user
 end

 def user_signed_in?
    !!current_user
 end

  def user_is_admin?
   return false if current_user.nil?
   return true if current_user.has_role?('admin')
   false
  end

  def user_is_site_manager?
   return false if current_user.nil?
   return true if current_user.id == @site.owner_id
   false
  end

 helper_method  :current_user,:signed_in?, :user_signed_in?, :user_is_admin?, :user_is_site_manager?

 def current_user=(user)
   @current_user = user
   logger.info "Current user is #{@current_user.name}"
   session[:user_id] = user.nil? ? user : user.id
 end

private
 
  def check_for_vanity_domains

      @site = Site.vanity(request.domain, request.subdomains)


    if @site
       session[:site_id] = @site.id
      if request.host == @site.domain
        set_cookie_domain(@site.domain)
      end
    end
  end

  def determine_site

    if current_user
      @site = current_user.site
      if @site.blank?
        @site = Site.where("id = 1").first
        current_user.site_id = @site.id
        current_user.save
      end
      session[:site_id] = @site.id
    else
      @site = Site.vanity(request.domain, request.subdomains)

      if @site
         session[:site_id] = @site.id
        if request.host == @site.domain
          set_cookie_domain(@site.domain)
        end
      else
        @site = Site.where("id = 1").first
      end
      if @site.blank?
        @site =  Site.create(:name => 'Fantasy Odds Maker')

      end
    end
       session[:site_id] = @site.id
  end
 
  def authorize
    redirect_to login_url, alert: "Not authorized" if current_user.nil?
  end

  def login_required_filter
    return true if current_user
    redirect_to root_path, :alert => "Must be logged in "
  end

  def user_is_admin_filter?
   return false if current_user.nil?
   return true if current_user.has_role?('admin')
   redirect_to root_path, :alert => "Not Authorized! "
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
