class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password], @site.id)
    if user
      session[:user_id] = user.id
       daily_bonus = current_user.daily_login_bonus(@site.daily_login_bonus)
       if daily_bonus > 0
         daily_bonus_message = "You have been awarded #{daily_bonus} Daily Bonus"
       else
         daily_bonus_message = ''
       end
      redirect_to myaccount_url, :notice => "Logged in! #{daily_bonus_message}"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end


  def destroy
   session[:user_id] = nil
   session[:site_id] = nil
   redirect_to root_url, notice: "Logged out!"
  end


end
