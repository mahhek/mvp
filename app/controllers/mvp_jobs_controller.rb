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
        seller = transaction.seller_user
        seller.update_attribute("recent_balance", seller.recent_balance.to_f + transaction.price )
        transaction.update_attribute("is_fund_transfered",true)
      end      
    end
    flash[:notice] = "Done"
    redirect_to dashboard_path(current_user)
  end
end
