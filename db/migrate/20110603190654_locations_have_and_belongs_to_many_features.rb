class LocationsHaveAndBelongsToManyFeatures < ActiveRecord::Migration
  def self.up
    create_table :features_locations, :id => false do |t|
      t.references :feature, :location
    end
  end

  def self.down
    drop_table :features_locations
  end
end
