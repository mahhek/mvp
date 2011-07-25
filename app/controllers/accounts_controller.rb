class AccountsController < ApplicationController
  before_filter :require_user
  before_filter :load_user, :except => [ :send_contact_renter, :send_contact_owner, :send_end_rental, :post_a_reply ]
  

  def update_password
    @user = User.find_by_id(params[:id])
    @user.errors.add :password, "is required" if params[:password].blank?
    @user.errors.add :password_confirmation, "is required" if params[:password_confirmation].blank?
    @user.errors.add_to_base "Password and confirmation must match" if params[:password] != params[:password_confirmation]
    if @user.errors.size > 0
      return render :action => "show"
    else
      @user.update_attribute("password",params[:password])
      flash[:notice] = "Password changed Successfully."
      return redirect_to account_path(@user)
    end
  end

  def dashboard    
  end

  def withdraw_amount
    if @user.recent_balance.to_f > 0.0
      @transaction = Transaction.new
      @transaction.confirmation_number = confirmation_number
      @transaction.price = @user.recent_balance
      @transaction.withdrawer = @user.id
      @transaction.withdrawal_amount = @user.recent_balance
      @transaction.save

      @user.update_attribute("recent_balance", @user.recent_balance - @user.recent_balance )

      flash[:notice] = "Amount withdrawal successfully!"
      redirect_to account_path(@user)
    else
      flash[:notice] = "No Amount to withdraw!"
      redirect_to account_path(@user)
    end
  end

  def update_request_status
    @message = Message.find_by_id(params[:id])

    @request_for_location = @message.locations_user
    @request_for_location.status = params["request_status_#{@message.id}_#{@request_for_location.id}"]
    @request_for_location.request_response_date = Date.current
    @text = ""
    p "--------------------------------------------------"
    p params["request_status_#{@message.id}_#{@request_for_location.id}"]
    case params["request_status_#{@message.id}_#{@request_for_location.id}"].to_i
    when LocationsUser::PENDING
      @text = "Stauts udpated."
    when LocationsUser::ACCEPTED
      @request_for_location.location.update_attribute("quantity",@request_for_location.location.quantity - 1)
      @text = "Request Accepted."
    when LocationsUser::REJECTED
      @text = "Request Rejected."
    when LocationsUser::ENDED
      @request_for_location.location.update_attribute("quantity",@request_for_location.location.quantity + 1)
      @text = "Rent Ended."
    end
    @request_for_location.save

    render :update do |page|
      page["drop_down_#{@message.id}_#{@request_for_location.id}"].hide
      page["updated_request_msg_div_#{@message.id}_#{@request_for_location.id}"].show
      page["updated_request_msg_div_#{@message.id}_#{@request_for_location.id}"].replace_html :text => @text
    end
  end
  
  
  def change_request_status    
    @request_for_location = LocationsUser.find_by_id(params[:id])
    @request_for_location.status = params[:status]
    @request_for_location.request_response_date = Date.current
    @text = ""
    
    case params[:status].to_i
    when LocationsUser::PENDING
      @text = "Stauts udpated."
    when LocationsUser::ACCEPTED
      @request_for_location.location.update_attribute("quantity",@request_for_location.location.quantity - 1)
      @request_for_location.transaction.update_attribute("status",Transaction::ACCEPTED)      
      @text = "Request Accepted."
    when LocationsUser::REJECTED
      @text = "Request Rejected."
    when LocationsUser::ENDED
      @request_for_location.location.update_attribute("quantity",@request_for_location.location.quantity + 1)
      @text = "Rent Ended."
    end
    @request_for_location.save
    flash[:notice] = @text
    redirect_to dashboard_path(current_user)    
  end



  def view_message
    @message = Message.find_by_id(params[:message_id])
    @message.update_attribute("is_read", true)
  end

  def post_a_reply
    @message = Message.new(params[:message])
    @message.save
    flash[:notice] = "Reply posted Successfully!"
    redirect_to your_messages_path(current_user)
  end

  def delete_message
    Message.find_by_id(params[:message_id]).destroy
    flash[:notice] = "Message deleted successfully!"
    redirect_to your_messages_path(current_user)
  end

  def contact_owner
    @message = Message.new
  end

  def send_contact_owner
    @message = Message.new(params[:message])
    @message.save
    render :update do |page|
      page << "$.modal.close();"
    end
  end

  def contact_renter
    @message = Message.new
    @request_for_location = LocationsUser.find_by_id(params[:request_id])
  end

  def send_contact_renter
    @message = Message.new(params[:message])
    @message.save
    render :update do |page|
      page << "$.modal.close();"
    end
  end

  def end_rental
    @message = Message.new
    @request_for_location = LocationsUser.find_by_id(params[:request_id])
  end

  def send_end_rental
    @message = Message.new(params[:message])
    @message.save
    @request_for_location = LocationsUser.find_by_id(@message.locations_user_id)
    @request_for_location.update_attribute("renting_end_date", params[:renting_end_date])
    render :update do |page|
      page << "$.modal.close();"
    end
  end


  protected

  def load_user
    @user = User.find_by_id(params[:id])
  end
end
