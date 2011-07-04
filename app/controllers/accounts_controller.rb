class AccountsController < ApplicationController
  before_filter :load_user

  def show    
  end

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


  protected

  def load_user
    @user = User.find_by_id(params[:id])
  end
end
