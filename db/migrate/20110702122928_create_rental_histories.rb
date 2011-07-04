class CreateRentalHistories < ActiveRecord::Migration
  def self.up
    create_table :rental_histories do |t|
      t.integer  :location_id
      t.integer  :creator_id
      t.integer  :renter_id
      t.date     :rent_date
      t.date     :end_date
      t.date     :payment_date
      t.float    :price

      t.timestamps
    end
  end

  def self.down
    drop_table :rental_histories
  end
end
