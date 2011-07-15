class CreateLocationsUsers < ActiveRecord::Migration
  def self.up
    create_table :locations_users do |t|
      t.integer :location_id
      t.integer :user_id
      t.string :status
      t.date :renting_start_date
      t.date :buyer_rental_date
      t.date :request_send_date
      t.date :request_response_date
      t.date :renting_end_date

      remove_column :locations, :renter_date
      remove_column :transactions, :rent_date
      remove_column :transactions, :reserve_status
      remove_column :messages, :transaction_id
      remove_column :messages, :rental_end_date
      add_column    :payments, :locations_user_id, :integer
      add_column    :transactions, :locations_user_id, :integer
      add_column    :messages, :locations_user_id, :integer

      t.timestamps
    end
  end

  def self.down
    drop_table :locations_users
  end
end
