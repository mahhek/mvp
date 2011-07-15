class PaymentsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_filter :load_location
  before_filter :require_user, :only => [:create]
  
  def can_user_send_request
    if @location.user_id == current_user.id
      flash[:notice] = "You can not rent your own space! Please try someone else's space, thanks."
      return false
    end
    @all_requests_of_current_user_for_location = current_user.locations_users.all :conditions => [ "location_id = ? and status = ?",@location.id, (LocationsUser::PENDING).to_i ]
    p "vvvvvvvvvvvvvv"
    p @location.inspect
    p @all_requests_of_current_user_for_location.size.inspect
    p @location.quantity.inspect
    
        
    unless @all_requests_of_current_user_for_location.size < @location.quantity
      flash[:notice] = "You have already sent request for this space. Please try some other space or wait for Owner's response, thanks."
      return false
    end
    return true
  end
  
  def new
    if current_user
      if can_user_send_request
        @request_for_location = LocationsUser.new
        @request_for_location.buyer_rental_date = params[:renter_date]
        @request_for_location.renting_start_date = @location.start_date
        @request_for_location.request_send_date = Date.current
        @request_for_location.user_id = current_user.id
        @request_for_location.location_id = @location.id
        @request_for_location.status = LocationsUser::PENDING
        @request_for_location.save
        @payment = @location.payments.build
      else
        redirect_to location_path(@location)
      end
    else
      session[:return_to] = location_path(@location)
      flash[:notice] = "You must be logged in to access this page."
      redirect_to :controller => "welcome", :action => "signup_and_signin"
    end
  end

  def create
    @payment = @location.payments.build(params[:payment])
    if @payment.save
      create_rent_out_transaction
      flash[:notice] = "Your reservation request has been sent to the seller."
      return redirect_to location_path(@location)
    else
      return render :action =>"new"
    end
  end

  protected

  def load_location
    @location = Location.find_by_id(params[:location_id])
  end

  def create_rent_out_transaction
    @transaction = Transaction.new
    @transaction.location_id = @location.id
    @transaction.creator_id = @location.creator_id
    @transaction.renter_id = current_user.id
    @transaction.confirmation_number = confirmation_number
    @transaction.list_type = @location.park_store
    @transaction.payment_date = @payment.locations_user.buyer_rental_date
    @transaction.locations_user_id = @payment.locations_user_id
    @transaction.price = @payment.amount
    @transaction.buyer_fee = calculate_fee(@payment.amount, @location.park_store, "Buyer")
    @transaction.seller_fee = calculate_fee(@payment.amount, @location.park_store, "Seller")
    @transaction.buyer_total = @payment.amount.to_f + @transaction.buyer_fee.to_f
    @transaction.seller_total = @payment.amount.to_f - @transaction.seller_fee.to_f
    @transaction.storably_total = @transaction.buyer_fee.to_f + @transaction.seller_fee.to_f
    @transaction.save!

    user = User.find_by_id(@transaction.creator_id)
    if user
      user.update_attribute("recent_balance", user.recent_balance.to_f + @transaction.seller_total.to_f )
    end

  end

  
  
end
