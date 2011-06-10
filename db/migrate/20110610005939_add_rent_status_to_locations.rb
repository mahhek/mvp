class AddRentStatusToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations , :rent_status, :string, :default => "Available"
  end

  def self.down
    remove_column :locations , :rent_status
  end
end
