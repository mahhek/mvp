class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  belongs_to :locations_user

  PENDING    = 1
  ACCEPTED   = 2

  after_create :send_owner_message

  def seller
    user = User.find_by_id(self.creator_id)
    "#{user.first_name} #{user.last_name[0..0].capitalize if user.last_name}"
  end

  def seller_user
    User.find_by_id(self.creator_id)
  end

  def renter
    user = User.find_by_id(self.renter_id)
    "#{user.first_name} #{user.last_name[0..0].capitalize if user.last_name}"
  end

  def renter_user
    User.find_by_id(self.renter_id)
  end

  def send_owner_message
    Message.new(:receiver_id => self.creator_id,
      :sender_id => self.renter_id,
      :locations_user_id => self.locations_user_id,
      :message_type => "Reservation",
      :subject => "Reservation Request: Please Respond within 24 Hours").save
  end
end
