class AddReserveStatusInTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :reserve_status, :boolean, :default => false
  end

  def self.down
    remove_column :transactions, :reserve_status
  end
end
