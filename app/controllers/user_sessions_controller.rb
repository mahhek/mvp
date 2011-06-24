class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  #  def create
  #    @user_session = UserSession.new(params[:user_session])
  #    if @user_session.save
  #      flash[:notice] = "Login successful !"
  #      render :update do |page|
  #        page << "window.location='/homepage'"
  #      end
  #    else
  #      render :update do |page|
  #        page[:errors_div_session].replace_html :partial => "layouts/errors", :locals => {:object => @user_session}
  #      end
  #    end
  #  end

  def create
    if request.xhr?
      @user_session = UserSession.new(params[:user_session])
      if @user_session.save
        flash[:notice] = "Login successful !"
        render :update do |page|
          if session[:return_to]
            if session[:return_to] == "/locations"
              session[:return_to] = "/locations/new"
            end
            page << "window.location='#{session[:return_to]}'"
            session[:return_to] = nil
          else
            page << "window.location='/'"
          end
        end
      else
        render :update do |page|
          #          page["signup-heading"].hide
          page["signup-heading"].replace_html :partial => "welcome/errors", :locals => {:object => @user_session}
        end
      end
    else
      if current_user
        if current_user_session.associatable_with_facebook_connect?
          if current_user_session.associate_with_facebook_connect
            flash[:notice] = "Your account is now associated with your facebook account"
            redirect_to root_url
          end
        else
          flash[:notice] = "Your facebook account is already connected"
          redirect_to profile_url
        end
      else
        @user_session = UserSession.new(params[:profile_session])
        if @user_session.save
          flash[:notice] = "Login successful!"
          redirect_to root_url
        else
          if @user_session.errors.on(:facebook)
            flash[:notice] = "An account already exists with this email, please login to connect it with your Facebook account."
            redirect_to login_path
          else
            flash[:notice] = "Could not login."
            render :action => :new
          end
        end
      end
    end
  end


  def forgot_password
    if current_user
      redirect_to edit_account_url
    else
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
        flash[:alert] = "Email #{params[:email]} wasn't found.  Perhaps you used a different one?  Or never registered or something?"
        render :action => :forgot_password
      end
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to root_url
  end
end
