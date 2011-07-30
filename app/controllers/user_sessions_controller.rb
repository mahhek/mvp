class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end

  #  def create
  #    @user_session = UserSession.new(params[:user_session])


  #      end
  #    else
  #      render :update do |page|
  #        page[:errors_div_session].replace_html :partial => "layouts/errors", :locals => {:object => @user_session}
  #      end
  #    end
  #    if @user_session.save
  #      flash[:notice] = "Login successful !"
  #      render :update do |page|
  #        page << "window.location='/homepage'"g
  #  end




  def create
    if request.xhr?
      @user_session = UserSession.new(params[:user_session])
      if @user_session.save
        #        flash[:notice] = "Login successful !"
        render :update do |page|
          if session[:return_to]
            page << "window.location='#{session[:return_to]}'"
            session[:return_to] = nil
          else
            user = User.find_by_email(@user_session.email)
            user.in_the_future
            page << "window.location='/account/#{user.id}/dashboard'"
            session[:return_to] = nil
          end
        end
      else
        render :update do |page|
          page["signup-color"].hide
          page["errors_div"].replace_html :partial => "welcome/errors", :locals => {:object => @user_session}
        end
      end
    else
      p "EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"
      p current_user.inspect
      p current_facebook_user.inspect
      p current_user_session.inspect

      if current_facebook_user
        @user = User.find_by_fb_user_id(current_facebook_user.id.to_i)
      end
      if @user.blank?

        @facebook_user = current_facebook_user.fetch

        @user = User.create :login => @facebook_user.email, :email => @facebook_user.email, :name => @facebook_user.name, :fb_user_id => @facebook_user.id
        if @user.save
          @user.profile = Profile.create(:benefactor_id => nil, :benefactor_invites =>   Setting.find_by_identifier("benefactor_invites").value.to_i)
          redirect_to :controller => "profiles", :action => "show", :id => @user.profile.id
        else
          render "new"
        end
      elsif @user.fb_user_id.nil?
        cc
        @user.update_attribute :fb_user_id, current_facebook_user.id
        redirect_to :controller => "dashboard", :url => "index"
      else
        ccc
        redirect_to :controller => "dashboard", :url => "index"
      end
    end
  end


  def forgot_password
    if current_user
      redirect_to edit_account_url
    else
      flash[:notice] = nil
      @user_session = UserSession.new
      @user = User.new
    end
  end

  def forgot_password_lookup_email
    
    if current_user
      redirect_to edit_account_url
    else
      user = User.find_by_email(params[:email])
      if user
        user.send_forgot_password!
        flash[:notice] = "A link to reset your password has been mailed to you."
      else
        flash[:notice] = "Email #{params[:email]} wasn't found.  Perhaps you used a different one?  Or never registered or something?"
        render :action => :forgot_password
      end
    end
  end

  def destroy
    current_user_session.destroy
    #    flash[:notice] = "Logout successful!"
    redirect_to root_url
  end
end
