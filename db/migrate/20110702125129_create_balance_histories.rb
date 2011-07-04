class CreateBalanceHistories < ActiveRecord::Migration
  def self.up
    create_table :balance_histories do |t|
      t.integer :user_id
      t.string :confirmation_number
      t.date :payment_date
      t.float :recent_balance
      t.float :seller_total
      t.float :withdrawal_amount
      t.float :balance

      t.timestamps
    end
  end

  def self.down
    drop_table :balance_histories
  end
end
