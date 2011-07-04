include Geokit::Geocoders

class Location < ActiveRecord::Base
  has_and_belongs_to_many :features
  has_many :avatars, :dependent => :destroy
  has_many :payments, :dependent => :destroy
  belongs_to :user
  

  validates_presence_of :address, :phone, :headline, :description, :price, :message => ""
  validates_format_of :phone, :allow_blank => true,
    :with => /^(1\s*[-\/\.]?)?(\((\d{3})\)|(\d{3}))\s*[-\/\.]?\s*(\d{3})\s*[-\/\.]?\s*(\d{4})\s*(([xX]|[eE][xX][tT])\.?\s*(\d+))*/
  
  before_save :update_park_store

  def update_park_store
    self.park_store = self.storage_type == "Parking Space" ? "Parking" : "Storage"
  end

  belongs_to :locatable, :polymorphic => true
  before_save :geolocate_from_address
  before_save :find_nearest_city

  def creator_id
    self.user_id.to_i
  end



  def find_nearest_city
    self.nearest_metro = calculate_distance_and_get_city
  end

  def calculate_distance_and_get_city
    if self.city != "Philadelphia" or self.city != "New York" or self.city != "San Francisco" or self.city != "Boston"

      philadelphia = GoogleGeocoder.geocode('Philadelphia')
      return "Philadelphia" if philadelphia.distance_from(self.city, :units => :miles) <= 25.to_f

      new_york = GoogleGeocoder.geocode('New York')
      return "New York" if new_york.distance_from(self.city, :units => :miles) <= 25.to_f

      san_francisco = GoogleGeocoder.geocode('San Francisco')
      return "San Francisco" if san_francisco.distance_from(self.city, :units => :miles) <= 25.to_f

      boston = GoogleGeocoder.geocode('Boston')
      return "Boston" if boston.distance_from(self.city, :units => :miles) <= 25.to_f
      
      return "Other"
    end
  end

  def geolocate_from_address
    
    # check if address has changed
    if self.address_changed?
      # check if an actual address has been set
      if self.address.to_s.strip.size > 0
        # find information related to address
        res = GoogleGeocoder.geocode(self.address)
        if(res)
          self.city = res.city
          self.county = res.province
          self.country_code = res.country_code
          self.region = res.state
          self.zipcode = res.zip
          self.street = res.street_address
          self.latitude = res.lat
          self.longitude = res.lng
          self.street_name = res.street_name
          self.street_number = res.street_number
        else
          # address not found
          self.city = nil
          self.county = nil
          self.country_code = nil
          self.region = nil
          self.zipcode = nil
          self.street = nil
          self.latitude = nil
          self.longitude = nil
        end
      end
    end
  end


end
