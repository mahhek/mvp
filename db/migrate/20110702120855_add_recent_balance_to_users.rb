class AddRecentBalanceToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :recent_balance, :float, :default => 0
  end

  def self.down
    remove_column :users, :recent_balance
  end
end
