class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.string :name

      t.timestamps
    end
    Feature.create(:name => "Heated")
    Feature.create(:name => "Air Conditioned")
    Feature.create(:name => "Elevator")
    Feature.create(:name => "Insured")
    Feature.create(:name => "Alarm")
    Feature.create(:name => "Web Camera")
    Feature.create(:name => "Doorman Building")
    Feature.create(:name => "Gated Community")
    Feature.create(:name => "Commercial Space")
    Feature.create(:name => "Residential Space")
    Feature.create(:name => "Covered Parking")
  end

  def self.down
    drop_table :features
  end
end
