class AddRenterDateInLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :renter_date, :date
  end

  def self.down
    remove_column :locations, :renter_date
  end
end
