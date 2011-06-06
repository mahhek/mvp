class WelcomeController < ApplicationController
  def index
    unless current_user
      @user_session = UserSession.new
      @user = User.new      
    end
  end

  def homepage  
  end
  
  def signup_and_signin
    flash[:notice] = "Welcome back to Storably!." if params[:id] == "signin"
    flash[:notice] = "Welcome to Storably!." if params[:id] == "signup"
  end

end
