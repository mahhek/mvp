class AddNearestMetroInLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :nearest_metro, :string
  end

  def self.down
    remove_column :locations, :nearest_metro
  end
end
