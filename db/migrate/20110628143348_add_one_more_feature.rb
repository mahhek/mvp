class AddOneMoreFeature < ActiveRecord::Migration
  def self.up
    Feature.create(:name => "Will help unload car/truck")
  end

  def self.down
    Feature.find_by_name(:name => "Will help unload car/truck").destroy
  end
end
