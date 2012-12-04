module ApplicationHelper
  def user_has_role?(role)
    return false if current_user.nil?
    return true if current_user.has_role?('admin')
    current_user.has_role?(role)
  end

  def user_is_admin?
   return false if current_user.nil?
   return true if current_user.has_role?('admin')
  end

  def user_is_track_owner?(track)
   return false if current_user.nil?
   return true if current_user.has_role?('admin')
   current_user.is_track_owner?(track)
  end

  def is_league_member?(league)
    return false if current_user.nil?
    leagueuser = Leagueuser.where("user_id = ? and league_id = ?", current_user.id, league.id)
    return false if leagueuser.blank?
    #return true if leagueuser.active == true
    true
  end  

  def is_league_owner?(league)
    return false if current_user.nil?
    return true if current_user.has_role?('admin')
    return true if league.owner_id == current_user.id
    false
  end

  def is_league_manager?(league)
   return false if current_user.nil?
   return true if is_league_owner?(league)
   leagueuser = Leagueuser.where("user_id = ? and league_id = ?", current_user.id, league.id)
   return false if leagueuser.nil?
   return true if leagueuser.status == 'Manager'
   false
  end

  def is_league_moderator?(league)
   return false if current_user.nil?
   return true if is_league_owner?(league)
   leagueuser = Leagueuser.where("user_id = ? and league_id = ?", current_user.id, league.id)
   return false if leagueuser.blank?
   return true if leagueuser.status == 'Moderator'
   false
  end

  def avatar_url(user)
    if user.avatar.present?
      user.avatar
   else
  #    default_url = "#{root_url}images/guest.png"
   #  gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
   #"http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
   url = Gravatar.new(user.email).image_url
   #nil
  end
end


end
