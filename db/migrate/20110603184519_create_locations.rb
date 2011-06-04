class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :address
      t.string :location_status
      t.integer :user_id
      t.string :unit
      t.string :phone
      t.string :storage_type
      t.string :accommodates
      t.string :floor
      t.string :access
      t.string :security
      t.string :headline
      t.text   :description
      t.datetime :start_date
      t.string :park_store
      t.float  :price
      t.string :country_code
      t.string :county
      t.string :region
      t.string :city
      t.string :zipcode
      t.string :street
      t.decimal :latitude, :precision => 15, :scale => 10
      t.decimal :longitude, :precision => 15, :scale => 10

      # reference the polymorphic model locatable
      t.references :locatable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
