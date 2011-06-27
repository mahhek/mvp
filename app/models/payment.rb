class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :location

  validates_presence_of :name, :email, :cc_number, :billing_address, :city, :state, :zip_code, :security_code, :phone_number
  validates_format_of :phone_number, :allow_blank => true,
    :with => /^(1\s*[-\/\.]?)?(\((\d{3})\)|(\d{3}))\s*[-\/\.]?\s*(\d{3})\s*[-\/\.]?\s*(\d{4})\s*(([xX]|[eE][xX][tT])\.?\s*(\d+))*/
	validates_format_of :email, :with => /^[\w\.=-]+@[\w\.-]+\.[\w]{2,3}$/
  validate :field_values

  def field_values
    errors.add_to_base('Please provide correct Name.') if self.name == "Name"
    errors.add_to_base('Please provide correct Email.') if self.email == "hello@example.com"
    errors.add_to_base('Please provide correct Billing address.') if self.billing_address == "Billing street address"
    errors.add_to_base('Please provide correct City.') if self.city == "City"
    errors.add_to_base('Please provide correct State.') if self.state == "State"
    errors.add_to_base('Please provide correct Zip code.') if self.zip_code == "Zip code"
    errors.add_to_base('Please provide correct Phone Number.') if self.phone_number == "Phone Number"
    errors.add_to_base('Please provide correct Credit Card Number.') if self.cc_number == "Credit Card Number"
    errors.add_to_base('Please provide correct Security Code.') if self.security_code == "Security Code"    
  end


end
