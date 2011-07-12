# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'utility'
require 'google'
require 'z_extended_string'
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def confirmation_number
    Base64.encode64(UUIDTools::UUID.random_create)[0..7]
  end
  
  def calculate_fee(amount, storage_type, person)
    case storage_type
    when "Parking"
      case person
      when "Buyer"
        return number_with_precision(( amount * FeeStructure.first.park_buyer ) / 100, :precision => 2)
      when "Seller"
        return number_with_precision(( amount * FeeStructure.first.park_seller ) / 100 , :precision => 2)
      end
    when "Storage"
      case person
      when "Buyer"
        return number_with_precision(( amount * FeeStructure.first.store_buyer ) / 100 , :precision => 2)
      when "Seller"
        return number_with_precision(( amount * FeeStructure.first.store_seller ) / 100 , :precision => 2)
      end
    end
  end  

  def admin_required
    unless current_user
      store_location
      unless session[:return_to] == "/"
        flash[:notice] = "You must be logged in to access this page"
      end
      redirect_to login_path
      return false
    end

    unless current_user.has_role?("Admin")
      flash[:notice] = "You don't have permission to access this page."
      redirect_to root_path
    end
  end

  def require_user
    logger.debug "ApplicationController::require_user"
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to "/welcome/signup_and_signin"
      return false
    end
  end

  def require_no_user
    logger.debug "ApplicationController::require_no_user"
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to "/"
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri 
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
end
