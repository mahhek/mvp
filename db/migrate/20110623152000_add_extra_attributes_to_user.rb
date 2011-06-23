class AddExtraAttributesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :zip_code, :string
    add_column :users, :phone_number, :string
    add_column :users, :occupation, :string
    add_column :users, :school_attended, :string
    add_column :users, :share, :string
    add_column :users, :photo_file_name, :string
    add_column :users, :photo_content_type, :string
    add_column :users, :photo_file_size, :string

  end

  def self.down
    remove_column :users, :zip_code
    remove_column :users, :phone_number
    remove_column :users, :occupation
    remove_column :users, :school_attended
    remove_column :users, :share
    remove_column :users, :photo_file_name
    remove_column :users, :photo_content_type
    remove_column :users, :photo_file_size
  end
end
