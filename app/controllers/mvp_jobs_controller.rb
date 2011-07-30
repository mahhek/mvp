class MvpJobsController < ApplicationController
  def fetch_and_expire_requests
    all_pending_requests = LocationsUser.find(:all, :conditions => ["status =?", "#{LocationsUser::PENDING}"])
    all_pending_requests.each do |pending_request|
      pending_request.update_attribute("status", "#{LocationsUser::NOTRESPONDED}") if (( Time.now - pending_request.request_send_date ) / 1.hour).round >= 0
    end
    flash[:notice] = "Done"
    redirect_to dashboard_path(current_user)
  end

  def fetch_accepted_transactions_update_user_balance
    transactions = Transaction.find(:all, :conditions => ["status =? and is_fund_transfered =?", "#{Transaction::ACCEPTED}",false])
    transactions.each do |transaction|
      if Time.now >= transaction.locations_user.buyer_rental_date
        transaction.locations_user.update_attribute("next_payment_time", transaction.locations_user.buyer_rental_date + 1.day)
        seller = transaction.seller_user
        seller.update_attribute("recent_balance", seller.recent_balance.to_f + transaction.price )
        transaction.update_attribute("is_fund_transfered",true)
      end      
    end
    flash[:notice] = "Done"
    redirect_to dashboard_path(current_user)
  end

  def recurring_payment_process
    recurring_requests = LocationsUser.find(:all, :conditions => ["status = ? and renting_end_date IS NULL and Date(next_payment_time) = ?", "#{LocationsUser::ACCEPTED}", "#{Date.today}"])
    recurring_requests.each do |recurring_request|
      seller = recurring_request.location.owner
      seller.update_attribute("recent_balance", seller.recent_balance.to_f + recurring_request.transaction.price )
      new_transaction = Transaction.new
      new_transaction = recurring_request.transaction.clone
      new_transaction.confirmation_number = confirmation_number
      new_transaction.payment_date = Time.now
      new_transaction.locations_user_id = nil
      new_transaction.is_fund_transfered = true
      new_transaction.save
      recurring_request.update_attribute("next_payment_time", recurring_request.next_payment_time + 1.day)
    end
    flash[:notice] = "Done"
    redirect_to dashboard_path(current_user)
  end

  def show_all_request_that_are_accepted_and_not_ended_and_do_not_have_next_payment_equals_to_todays_date_date
    @all_requests = LocationsUser.find(:all, :conditions => ["status = ? and renting_end_date IS NULL and Date(next_payment_time) > ?", "#{LocationsUser::ACCEPTED}", "#{Date.today}"])
    @user = current_user
  end

  def change_date
    @l_request = LocationsUser.find_by_id(params[:id])
    @l_request.update_attribute("next_payment_time", Time.now)
    flash[:notice] = "Date changed"
    redirect_to show_all_request_that_are_accepted_and_not_ended_and_do_not_have_next_payment_equals_to_todays_date_date_path
  end

  


  
end
