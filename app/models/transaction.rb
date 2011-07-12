class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :location

  after_create :send_owner_message

  def seller
    user = User.find_by_id(self.creator_id)
    "#{user.first_name} #{user.last_name[0..0].capitalize if user.last_name}"
  end

  def renter
    user = User.find_by_id(self.renter_id)
    "#{user.first_name} #{user.last_name[0..0].capitalize if user.last_name}"
  end

  def send_owner_message
    Message.new(:receiver_id => self.creator_id,
      :sender_id => self.renter_id,
      :transaction_id => self.id,
      :message_type => "Reservation",
      :subject => "Reservation Request: Please Respont within 24 Hours.").save
  end
end
