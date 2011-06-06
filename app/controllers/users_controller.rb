class UsersController < ApplicationController

  def create
    @user = User.new(params[:user])
    @user.roles << Role.find_by_name("User")
    if @user.save
      @user.activate!
      flash[:notice] = "Your account has been created!"
      render :update do |page|
        page << "window.location='/welcome/signup_and_signin'"
      end
    else
      render :update do |page|
        page[:flash_messages_div].hide
        page[:errors_div].replace_html :partial => "welcome/errors", :locals => {:object => @user}
      end
    end
  end

  def activate
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
    if @user.activate!
      UserSession.create(@user, false)
      @user.send_activation_confirmation!
      redirect_to homepage_url
    else
      render :action => :new
    end
  end

  def new
    @user = User.new
  end


  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  def reset_password
    if @user = User.find_using_perishable_token(params[:reset_password_code], 1.week)
    else
      @user = User.new
    end
  end

  def reset_password_submit
    @user = User.find_using_perishable_token(params[:reset_password_code], 1.week)
    @user.active = true
    if @user.update_attributes(params[:user].merge({:active => true}))
      flash[:notice] = "Successfully reset password."
      redirect_to @user
    else
      flash[:notice] = "There was a problem resetting your password."
      render :action => :reset_password
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_url) }
      format.xml  { head :ok }
    end
  end

  
end
