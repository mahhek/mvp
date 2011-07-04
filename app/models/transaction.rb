class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :location

  def seller
    user = User.find_by_id(self.creator_id)
    "#{user.first_name} #{user.last_name[0..0].capitalize if user.last_name}"
  end

  def renter
    user = User.find_by_id(self.renter_id)
    "#{user.first_name} #{user.last_name[0..0].capitalize if user.last_name}"
  end
end
