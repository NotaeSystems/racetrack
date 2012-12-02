class AuthenticationsController < ApplicationController
 

 def create
    auth = request.env["omniauth.auth"]
 
    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
 
    if authentication
      # Authentication found, sign the user in.
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, authentication.user)
    else
      # Authentication not found, thus a new user.
      ## check to see if user with email exists
      new_user = User.new
      
      new_user.apply_omniauth(auth)
      existing_user = User.where("email = ?", new_user.email)
      if existing_user
        sign_in_and_redirect edit_user_path(existing_user)
      else
        if new_user.save(:validate => false)
          flash[:notice] = "Account created and signed in successfully."
          sign_in_and_redirect edit_user_path(new_user)
        else
          flash[:error] = "Error while creating a user account. Please try again."
          redirect_to root_url
        end
      end
    end
  end
end
