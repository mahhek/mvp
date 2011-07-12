class Message < ActiveRecord::Base
  belongs_to :transaction
  
  def from
    User.find_by_id(self.sender_id)
  end

  def to
    User.find_by_id(self.receiver_id)
  end

end
