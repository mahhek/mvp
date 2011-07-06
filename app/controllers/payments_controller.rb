class PaymentsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_filter :load_location
  before_filter :require_user, :only => [:new,:create]
  
  def new
    @payment = @location.payments.build
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
    @transaction.rent_date = Date.current
    @transaction.payment_date = @location.start_date
    @transaction.price = @payment.amount
    @transaction.buyer_fee = calculate_fee(@payment.amount, @location.park_store, "Buyer")
    @transaction.seller_fee = calculate_fee(@payment.amount, @location.park_store, "Seller")
    @transaction.buyer_total = @payment.amount.to_f + @transaction.buyer_fee.to_f
    @transaction.seller_total = @payment.amount.to_f - @transaction.seller_fee.to_f
    @transaction.storably_total = @transaction.buyer_fee.to_f + @transaction.seller_fee.to_f
    @transaction.save!

    user = User.find_by_id(@transaction.creator_id)
    if user
      puts "=========="
      puts user.recent_balance.inspect
      puts @transaction.seller_total.inspect
      user.update_attribute("recent_balance", user.recent_balance.to_f + @transaction.seller_total.to_f )
    end

  end

  
  
end
