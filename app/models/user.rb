class User < ActiveRecord::Base
  acts_as_authentic do |c|

    c.login_field = 'email'
    c.require_password_confirmation = false
    password_length_constraints = c.validates_length_of_password_field_options.reject { |k,v| [:minimum, :maximum].include?(k) }
    c.validates_length_of_password_field_options = password_length_constraints.merge :within => 6..24

  end
  attr_accessor :password_confirmation

  

  

  has_and_belongs_to_many :roles
  has_many :locations, :order => "created_at DESC"
  has_many :payments, :dependent => :destroy
  
  has_attached_file :photo, :styles => { :medium => "212x182#", :thumb => '100x100#', :tiny => "30x30#" },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => "/:style/:id/:filename"
  # has_attached_file :photo, :styles => { :'300' => "300x300#", :'150' => '150x150#', :'100' => "100x100#", :'70' => "70x70#", :'50' => "50x50#", :'30' => "30x30#" }, :default_url => '/images/profile/missing_:style.png'

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

  def transactions
    Transaction.all :conditions => ["creator_id =? or renter_id=? or withdrawer=?",self.id,self.id,self.id]
  end

  def active?
    active
  end

  def activate!
    self.active = true
    save
  end

  def deactivate!
    self.active = false
    save
  end

  def send_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def send_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end

  def email_address_with_name
    "#{self.name} <#{self.email}>"
  end

  def send_forgot_password!
    deactivate!
    reset_perishable_token!
    Notifier.deliver_forgot_password(self)
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
end

#Please find answers in blue.
#
#On Wed, Jun 29, 2011 at 5:58 PM, Apu Gupta <apu@storably.com> wrote:
#
#    Mahhek,
#
#    The following are bugs vs. changes:
#
#    Bugs:
#    Page 1: Missing Comma
#
#    FIXED
#
#    Page 4: Pressing enter should not advance to add photos
#
#    FIXED
#
#    Page 4: Dollar sign & .00 alignment changes upon display of error message (designer issue?)
#
#    FIXED
#
#    Page 5: Text placement issue (designer issue?)
#
#    FIXED
#
#    Page 6: Photo uploading issue - this is a bug
#
#    FIXED
#
#    Page 7: "Give us your zip code" - simple spelling mistake, bug
#
#    FIXED
#
#    Page 8: Zip code error appears even though zip code has been entered
#
#    FIXED
#
#    Page 8: When uploading photo, no photo displays
#
#    FIXED
#
#    Page 9: New York map comes up on a search for Boston
#
#    With all due respect, this is not a bug, remember, when we implement this, if there was not any result found after search then there wasn't any map for displaying, then Josh said me in email that please show NY map if you didn't find any, Then I implement that without any confirmation of time. So If you want me to do this for each value of drop down then increase my hours 2 to 3.5 ( This includes page number 11's logic as it didn't implement yet ). Thanks.
#
#    Page 10: Designer issue
#
#    YES, its designer's issue, please ask him to provide me green and red alert fields. He might forgot.
#
#    Page 11: I thought this logic had already been implemented, if not, tell me.
#
#    Changes:
#    Page 1: Delete "Response Rate" - this cannot take more than 5 minutes
#
#   FIXED
#
#    Page 1: Placing profile information on a blue background instead of white box - designer issue with you feeding the data - 30 mins
#
#   FIXED  (without designer#'s input)
#
#    Page 2: Delete "Affiliates" link - 5 minutes
#
#   FIXED
#
#    Page 3 & 8: Error message handling - you have done this before and now it needs to be applied here - 1 hour
#
#   FIXED  ( Need Red alert div from designer)
#
#    Page 4: Place "*" next to required fields - 5 mins
#
#   FIXED
#
#    Page 7: Change "Hello Lucas" text to black and remove link - 5 mins
#
#   FIXED
#

