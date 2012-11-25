module ApplicationHelper
  def user_has_role?(role)
   return false if current_user.nil?
   return true if current_user.has_role?('admin')
   current_user.has_role?(role)
  end

  def user_is_track_owner?(track)
   return false if current_user.nil?
   return true if current_user.has_role?('admin')
   current_user.is_track_owner?(track)
  end
end
