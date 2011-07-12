class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :receiver_id
      t.integer :sender_id
      t.string  :subject
      t.text    :body
      t.string  :message_type
      t.integer :transaction_id
      t.date    :rental_end_date
      t.boolean :is_read, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
