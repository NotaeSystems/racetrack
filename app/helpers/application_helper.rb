module ApplicationHelper
  def horses_list
    horse_array = Array.new
    horses = @race.horses.where(:status => 'Open')
    horses.each do |horse|
     horse_array << [horse.name, horse.id]
    end
    return horse_array
  end

  
  def allowed_bets
    allowed_bets_list = []
    if @horse.race.win?
      allowed_bets_list = allowed_bets_list + ['Win']
    end
    if @horse.race.place?   
      allowed_bets_list = allowed_bets_list + ['Place']
    end
    if @horse.race.show? 
      allowed_bets_list = allowed_bets_list + ['Show']
    end
    allowed_bets_list
  end

  def user_has_role?(role)
    return false if current_user.nil?
    return true if current_user.has_role?('admin')
    current_user.has_role?(role)
  end

  def is_track_member?(track)
   return false if current_user.nil?
   trackuser = Trackuser.where(:user_id => current_user.id, :track_id => track.id).first
   unless trackuser.blank?
     return true if ['Member', 'Manager'].include?(trackuser.status)
   end  
   return false
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

  def user_is_track_manager?(track)
   return false if current_user.nil?
   return true if current_user.has_role?('admin')
   current_user.is_track_manager?(track)
  end

  def is_league_member?(league)
    return false if current_user.nil?
    return true if league.owner_id == current_user.id
    leagueuser = Leagueuser.where("user_id = ? and league_id = ? and status NOT IN ('Pending', 'Banned')", current_user.id, league.id).first
    return false if leagueuser.blank?
    #return true if leagueuser.active == true
    true
  end  

  def is_pending_league_member?(league)
    return false if current_user.nil?

    leagueuser = Leagueuser.where("user_id = ? and league_id = ? and status = 'Pending'", current_user.id, league.id).first
    return false if leagueuser.blank?
    #return true if leagueuser.active == true
    true
  end

  def is_pending_track_member?(track)
    return false if current_user.nil?
    trackuser = Trackuser.where("user_id = ? and track_id = ? and status = 'Pending'", current_user.id, track.id).first
    return false if trackuser.blank?
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
   leagueuser = Leagueuser.where("user_id = ? and league_id = ?", current_user.id, league.id).first
   return false if leagueuser.nil?
   return true if leagueuser.status == 'Manager'
   false
  end

  def is_league_moderator?(league)
   return false if current_user.nil?
   return true if is_league_owner?(league)
   leagueuser = Leagueuser.where("user_id = ? and league_id = ?", current_user.id, league.id).first
   return false if leagueuser.blank?
   return true if leagueuser.status == 'Moderator'
   false
  end

  def avatar_url(user)
   return nil if user.blank?
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
