class ChangeTransactionDatesDataType < ActiveRecord::Migration
  def self.up
    change_column :locations_users, :renting_start_date, :datetime
    change_column :locations_users, :buyer_rental_date, :datetime
    change_column :locations_users, :request_send_date, :datetime
    change_column :locations_users, :request_response_date, :datetime
    change_column :locations_users, :renting_end_date, :datetime
  end

  def self.down
    change_column :locations_users, :renting_start_date, :date
    change_column :locations_users, :buyer_rental_date, :date
    change_column :locations_users, :request_send_date, :date
    change_column :locations_users, :request_response_date, :date
    change_column :locations_users, :renting_end_date, :date
  end
end
