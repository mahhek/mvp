class UsersController < ApplicationController

  def create
    @user = User.new(params[:user])
    @user.roles << Role.find_by_name("User")
    @user.activate!
    if @user.save      
      @user.update_attribute("recent_balance", 0.to_f)
      flash[:notice] = "Your account has been created!"
      render :update do |page|
        page << "window.location='/'"
      end
    else
      render :update do |page|
        page["signup-color"].hide
        page["errors_div"].replace_html :partial => "welcome/errors", :locals => {:object => @user}
      end
    end
  end

  def create_facebook_user
    
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
    @user = User.find_by_id(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated!"
      redirect_to edit_user_path(@user)
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
      redirect_to edit_user_path(@user)
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
