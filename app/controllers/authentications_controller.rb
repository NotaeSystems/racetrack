class AuthenticationsController < ApplicationController
 skip_before_filter :verify_authenticity_token, only: :create

  def backdoor
   email = params[:email]
   user = User.where(:email => email).first
   logger.info "Backdoor user is #{user.name}"
   self.current_user = user
   redirect_to myaccount_url
  end

  def index
    @authentications = Authentication.page(params[:page]).per_page(30)
  end

  def edit
    @authentication = Authentication.find(params[:id])
  end

  def update
    @authentication = Authentication.find(params[:id])

    respond_to do |format|
      if @authentication.update_attributes(params[:authentication])
        format.html { redirect_to @authentication,  notice: 'Authentication was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

def create
  auth = request.env['omniauth.auth']
  # Find an identity here
  @authentication = Authentication.find_with_omniauth(auth)

  if @authentication.nil?
    # If no identity was found, create a brand new one here
    @authentication = Authentication.create_with_omniauth(auth)
  end

  if signed_in?
    if @authentication.user == current_user
      # User is signed in so they are trying to link an identity with their
      # account. But we found the identity and the user associated with it 
      # is the current user. So the identity is already associated with 
      # this user. So let's display an error message.
      ## update token
      @authentication.token = auth['credentials']['token']
      @authentication.save
      redirect_to myaccount_url, notice: "Already linked that account!"
    else
      # The identity is not associated with the current_user so lets 
      # associate the identity
      @authentication.user = current_user

      @authentication.save()
      redirect_to myaccount_url, notice: "Successfully linked that account!"
    end
  else
    if @authentication.user.present?
      # The identity we found had a user associated with it so let's 
      # just log them in here
      self.current_user = @authentication.user
      redirect_to myaccount_url, notice: "Signed in!"
    else
      # No user associated with the identity so we need to create a new one
      new_user = @authentication.create_new_user(auth)
      new_user.add_achievement('Neophyte', session[:provider])
      session[:provider] = auth['provider']
      @authentication.user = new_user
      @authentication.save()
      current_user = new_user
      redirect_to myaccount_url, notice: "Welcome! Your are now signed in."
    end
  end
end



  def create1
    auth = request.env["omniauth.auth"]
 
    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
    
    
    if authentication
      if user_signed_in?
        flash[:notice] = "Your #{authentication.provider} account is already linked."
         redirect_to myaccount_url
      else
        # Authentication found, sign the user in.
        flash[:notice] = "Signed in successfully."
        session[:provider] = auth['provider']
        ## refresh token #################
        authentication.token = auth['credentials']['token']
        authentication.save
        ##########################
        sign_in_and_redirect(:user, authentication.user)

      end
    else
      # Authentication not found, thus a new user.
      ## check to see if user with email exists
      if user_signed_in?

      else
        email = auth['extra']['raw_info']['email']
        # existing_user = User.where("email = ?", email).first
        existing_user = current_user
        if existing_user
          existing_user.apply_omniauth(auth)
          existing_user.name = auth["info"]["name"]
          existing_user.avatar = auth["info"]["image"]
          existing_user.save
          session[:provider] = auth['provider']
          flash[:notice] = "Signed in successfully with #{session[:provider]}."
          sign_in_and_redirect(:user, existing_user)
        else
          new_user = User.new

          new_user.apply_omniauth(auth)
          new_user.name = auth["info"]["name"]
          new_user.avatar = auth["info"]["image"]
          new_user.status = 'Member'
          new_user.add_role :user
          session[:provider] = auth['provider']
          if new_user.save(:validate => false)
            ## assign neophyte achievement to user

            new_user.add_achievement('Neophyte', session[:provider])
     

            flash[:notice] = "Account created and signed in successfully with #{session[:provider]}."
            # if auth[:provider].to_s == 'facebook'
            # new_user.facebook.put_wall_post("I joined Fantasy Odds Maker.",  :link => "http://www.fantasyoddsmaker.com}")
            #end
            sign_in_and_redirect(:user, new_user)
          else
            flash[:error] = "Error while creating a user account. Please try again."
            redirect_to root_url
          end
        end
      end
    end  
  end
end
