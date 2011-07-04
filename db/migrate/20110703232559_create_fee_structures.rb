class CreateFeeStructures < ActiveRecord::Migration
  def self.up
    create_table :fee_structures do |t|
      t.float :park_buyer
      t.float :park_seller
      t.float :store_buyer
      t.float :store_seller

      t.timestamps
    end

    FeeStructure.new( :park_buyer => 15, :park_seller => 0, :store_buyer => 8, :store_seller => 3 ).save
  end

  def self.down
    drop_table :fee_structures
  end
end
