class Location < ActiveRecord::Base
  has_and_belongs_to_many :features
  has_many :avatars, :dependent => :destroy
  belongs_to :user

  validates_presence_of :address, :phone
  validates_format_of :phone, :allow_blank => true,
	:with => /^(1\s*[-\/\.]?)?(\((\d{3})\)|(\d{3}))\s*[-\/\.]?\s*(\d{3})\s*[-\/\.]?\s*(\d{4})\s*(([xX]|[eE][xX][tT])\.?\s*(\d+))*/
  
  before_save :update_park_store

  def update_park_store
    self.park_store = self.storage_type == "Parking Space" ? "Parking" : "Storage"
  end
end
