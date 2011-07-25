class User < ActiveRecord::Base
  
  acts_as_authentic do |c|

    c.login_field = 'email'
    c.validate_login_field = false
    c.require_password_confirmation = false
    password_length_constraints = c.validates_length_of_password_field_options.reject { |k,v| [:minimum, :maximum].include?(k) }
    c.validates_length_of_password_field_options = password_length_constraints.merge :within => 6..24
    c.merge_validates_uniqueness_of_email_field_options :message => 'address is already registered.'

  end
  FACEBOOK_SCOPE = 'email,user_birthday'

  #  def before_connect(facebook_session)
  #    nnn
  #    self.first_name = facebook_session.first_name
  #    self.last_name = facebook_session.last_name
  #    self.email = facebook_session.email
  #    self.gender = facebook_session.gender
  #    self.password = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.username}--")[0,6]
  #    self.password_confirmation = self.password
  #    self.active = true
  #
  #    # Set other tokens
  #    self.single_access_token = Authlogic::Random.friendly_token
  #    self.perishable_token = Authlogic::Random.friendly_token
  #    reset_persistence_token
  #  end
  #
  #  def self.new_or_find_by_facebook_oauth_access_token(access_token, options = {})
  #    user = User.find_by_facebook_oauth_access_token(access_token)
  #    if user.blank?
  #      #code to create new user here
  #    end
  #    user
  #  end


  def before_connect(facebook_user)
    # facebook_uid and facebook_access_token are automatically set by the plugin
    self.first_name = facebook_user.first_name
    self.last_name = facebook_user.last_name
    self.gender = facebook_user.gender
    # Set other tokens
    self.single_access_token = Authlogic::Random.friendly_token
    self.perishable_token = Authlogic::Random.friendly_token
    reset_persistence_token
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
  
  def accepted_requests_of_customers_of_all_locations
    self.locations.collect { |location| location.customers_accepted_requests }.flatten
  end

  def rental_requests_of_customers_of_all_locations
    self.locations.collect { |location| location.customers_rental_requests }.flatten
  end

  def cancellation_requests_of_customers_of_all_locations
    self.locations.collect { |location| location.customers_cancellation_requests }.flatten
  end

  has_many :payments, :dependent => :destroy
  has_many :sent_messages, :class_name => "Message", :foreign_key => :sender_id, :order => "created_at DESC"
  has_many :received_messages, :class_name => "Message", :foreign_key => :receiver_id, :order => "created_at DESC"



  has_many :locations_users
  has_many :own_accepted_requests, :class_name => "LocationsUser", :conditions => ['locations_users.status = ?', "#{LocationsUser::ACCEPTED}"]
  has_many :pending_requested_locations, :through => :locations_users, :source => "location", :conditions => ['locations_users.status = ?',"#{LocationsUser::PENDING}"]
  has_many :accepted_requested_locations, :through => :locations_users, :source => "location", :conditions => ['locations_users.status = ?',"#{LocationsUser::ACCEPTED}"]
  has_many :rejected_requested_locations, :through => :locations_users, :source => "location", :conditions => ['locations_users.status = ?',"#{LocationsUser::REJECTED}"]

  
  
  has_attached_file :photo, :styles => { :medium => "212x182#", :thumb => '100x100#', :tiny => "30x30#" },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => "/:style/:id/:filename"
  # has_attached_file :photo, :styles => { :'300' => "300x300#", :'150' => '150x150#', :'100' => "100x100#", :'70' => "70x70#", :'50' => "50x50#", :'30' => "30x30#" }, :default_url => '/images/profile/missing_:style.png'

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

  def have_not_requested?(location_id)
    Transaction.find_by_location_id_and_renter_id(location_id,self.id)
  end

  def unread_messages
    Message.find(:all, :conditions => ["receiver_id = ? and is_read=?", self.id.to_i, false] )
  end

  def transactions
    Transaction.all :conditions => ["( creator_id =? or renter_id=? or withdrawer=? ) and status = ? and is_fund_transfered =?",self.id,self.id,self.id, "#{Transaction::ACCEPTED}",1],
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

