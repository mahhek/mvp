class User < ActiveRecord::Base
  acts_as_authentic do |c|

    c.login_field = 'email'
    c.require_password_confirmation = false
    password_length_constraints = c.validates_length_of_password_field_options.reject { |k,v| [:minimum, :maximum].include?(k) }
    c.validates_length_of_password_field_options = password_length_constraints.merge :within => 6..24

  end

  validate :field_values, :on => :update

  def field_values
    errors.add_to_base('Please provide correct Zip code.') if self.zip_code == "19146"
    errors.add_to_base('Please provide correct Phone Number.') if self.phone_number == "(555) 123-4567"    
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
