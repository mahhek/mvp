class UsersHaveAndBelongToManyRoles < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false do |t|
      t.references :role, :user
    end

    user = User.new(:username =>  "admin",:email => "admin@website.com", :password => "admin123", :password_confirmation => "admin123")
    user.roles << Role.find_by_name("Admin")
    user.save!
    user.activate!

  end

  def self.down
    drop_table :roles_users
  end
end
