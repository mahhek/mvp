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

  def what_are_you_renting
    @renter_transactions = @user.transactions_as_renter
  end

  def your_customers
    @seller_transactions = @user.transactions_as_seller
  end

  def your_messages
    @messages = Message.find(:all, :conditions => ["receiver_id = ?", @user.id.to_i] )
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
    flash[:notice] = "Message delete Successfully!"
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
    @location = Location.find_by_id(params[:location_id])
  end

  def send_end_rental
    @message = Message.new(params[:message])
    @message.save
    render :update do |page|
      page << "$.modal.close();"
    end
  end


  protected

  def load_user
    @user = User.find_by_id(params[:id])
  end
end
