class AddAttributesToLocations < ActiveRecord::Migration
  def self.up
    add_column :users, :renter_id, :integer
    add_column :users, :rent_date, :date
  end

  def self.down
    remove_column :users, :renter_id
    remove_column :users, :rent_date
  end
end
