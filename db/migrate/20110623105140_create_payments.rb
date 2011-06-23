class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :location_id
      t.integer :user_id
      t.float  :amount
      t.string :name
      t.string :email
      t.string :cc_number
      t.string :billing_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :expire_month
      t.string :expire_year
      t.string :security_code
      t.string :phone_number
      t.string :hear_about_us

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
