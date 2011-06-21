class AddApartmentToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :apartment,  :string
  end

  def self.down
    remove_column :locations, :apartment
  end
end
