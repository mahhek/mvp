class AddStatusToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :status, :integer
    add_column :transactions, :is_fund_transfered, :boolean, :default => false
  end

  def self.down
    remove_column :transactions, :status
    remove_column :transactions, :is_fund_transfered
  end
end
