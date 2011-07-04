class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.string :confirmation_number
      t.integer :location_id
      t.float :price
      t.string :list_type
      t.float :buyer_fee
      t.float :seller_fee
      t.float :buyer_total
      t.float :seller_total
      t.float :storably_total
      t.date :rent_date
      t.date :payment_date
      t.integer :creator_id
      t.integer :renter_id
      t.integer :withdrawer
      t.float :withdrawal_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
