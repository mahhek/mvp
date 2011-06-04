class WelcomeController < ApplicationController
  def index
    unless current_user
      @user_session = UserSession.new
      @user = User.new
    end
  end

  def homepage  

  end
end
