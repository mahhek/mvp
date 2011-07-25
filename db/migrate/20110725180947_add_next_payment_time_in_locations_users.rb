class AddNextPaymentTimeInLocationsUsers < ActiveRecord::Migration
  def self.up
    add_column :locations_users, :next_payment_time, :datetime    
  end

  def self.down
    remove_column :locations_users, :next_payment_time
  end
end
