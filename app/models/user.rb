class User < ActiveRecord::Base
  acts_as_authentic do |c|

    c.login_field = 'email'
    c.validate_login_field = false
    c.require_password_confirmation = false
    password_length_constraints = c.validates_length_of_password_field_options.reject { |k,v| [:minimum, :maximum].include?(k) }
    c.validates_length_of_password_field_options = password_length_constraints.merge :within => 6..24
    c.merge_validates_uniqueness_of_email_field_options :message => 'address is already registered.'

  end
  attr_accessor :password_confirmation

  validate :field_values



  def field_values
    errors.add_to_base('Please provide correct City.') if self.city == "Please enter your city"
    errors.add_to_base('Please provide correct Zip Code.') if self.zip_code == "Please enter your zip code"
    errors.add_to_base('Please provide correct Phone Number.') if self.phone_number == "Please enter your phone number"
    errors.add_to_base('Please provide correct Occupation.') if self.occupation == "What do you do for a living?"
    errors.add_to_base('Please provide correct School Attended.') if self.school_attended == "Where did you go to school?"
  end
  

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

  def messages    
    Message.find(:all, :conditions => ["receiver_id = ?", self.id.to_i] )
  end

  def rented_locations
    renter_transactions = Transaction.find(:all,:conditions => ["renter_id = ? ", self.id.to_i])
    renter_transactions.collect { |transaction| transaction.location }   
  end

  def have_not_requested?(location_id)
    Transaction.find_by_location_id_and_renter_id(location_id,self.id)
  end

  def unread_messages
    Message.find(:all, :conditions => ["receiver_id = ? and is_read=?", self.id.to_i, false] )
  end

  def transactions
    Transaction.all :conditions => ["( creator_id =? or renter_id=? or withdrawer=? ) and reserve_status=?",self.id,self.id,self.id,true],
      :order => "created_at Desc"
  end

  def transactions_as_renter
    Transaction.all :conditions => [" renter_id=? ",self.id], :order => "created_at Desc"
  end

  def transactions_as_seller
    Transaction.all :conditions => [" creator_id=? ",self.id], :order => "created_at Desc"
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

