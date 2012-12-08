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
      new_user.name = auth["info"]["name"]
      new_user.avatar = auth["info"]["image"]
      new_user.status = 'Member'
      
      new_user.add_role :user
      existing_user = User.where("email = ?", new_user.email).first
      if existing_user
        existing_user.name = auth["info"]["name"]
        existing_user.avatar = auth["info"]["image"]
        existing_user.save
        session[:provider] = auth['provider']
        flash[:notice] = "Signed in successfully with #{session[:provider]}."
        sign_in_and_redirect(:user, existing_user)
      else
        if new_user.save(:validate => false)
          session[:provider] = auth['provider']
          flash[:notice] = "Account created and signed in successfully with #{session[:provider]}."
          if session[:provider] == 'facebook'
            new_user.facebook.put_wall_post("I joined Fantasy Odds Maker.")
          end
          sign_in_and_redirect(:user, new_user)
        else
          flash[:error] = "Error while creating a user account. Please try again."
          redirect_to root_url
        end
      end
    end
  end
end
