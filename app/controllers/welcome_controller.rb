class WelcomeController < ApplicationController
  def index
    unless current_user
      @user_session = UserSession.new
      @user = User.new      
    end
    @spaces = Location.all
  end

  def homepage
    render :layout => 'inner'
  end
  
  def signup_and_signin
    flash[:notice] = "Welcome back to Storably!" if params[:id] == "signin"
    flash[:notice] = "Welcome to Storably!" if params[:id] == "signup"
  end

  def new_requested_city
    render :update do |page|
      if params[:requested_city] and params[:requested_city] == "Add My City!"
        page[:other_requested_city_div].show
        page[:other_requested_city_div].replace_html :partial => "requested_city"
      else
        page[:other_requested_city_div].replace_html ""
      end
    end
  end

  def tell_me_more
    render :layout => "inner"
  end

end
