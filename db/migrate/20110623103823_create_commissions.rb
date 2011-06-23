class CreateCommissions < ActiveRecord::Migration
  def self.up
    create_table :commissions do |t|
      t.float :buyer
      t.float :seller

      t.timestamps
    end

    Commission.new(:buyer => 0.08, :seller => 0.08).save
  end

  def self.down
    drop_table :commissions
  end
end
