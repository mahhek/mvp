class AddStreetNameAndStreetNumberInLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :street_name, :string
    add_column :locations, :street_number, :string
  end

  def self.down
    remove_column :locations, :street_name
    remove_column :locations, :street_number
  end
end
