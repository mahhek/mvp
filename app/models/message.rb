class Message < ActiveRecord::Base
  belongs_to :transaction
  belongs_to :locations_user
  belongs_to :sender, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User' 
end
