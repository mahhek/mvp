class PaymentsController < ApplicationController
  before_filter :load_location
  
  def new
    @payment = @location.payments.build
  end

  def create
    @payment = @location.payments.build(params[:payment])
    if @payment.save
      flash[:notice] = "Request has been sent to the seller."
      return redirect_to location_path(@location)
    else
      flash[:notice] = "Unable to save information!"
      return render :action =>"new"
    end
  end

  protected

  def load_location
    @location = Location.find_by_id(params[:location_id])
  end
end
