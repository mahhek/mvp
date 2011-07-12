class AddQuantityToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :quantity, :integer, :default => 1.to_i
  end

  def self.down
    add_column :locations, :quantity
  end
end
