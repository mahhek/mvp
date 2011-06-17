class AddEmailInRequestedCities < ActiveRecord::Migration
  def self.up
    add_column :requested_cities, :email, :string
  end

  def self.down
    remove_column :requested_cities, :email
  end
end
