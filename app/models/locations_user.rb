class LocationsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :location

  has_one :transaction
  has_one :payment
  has_one :messagae

  PENDING    = 1
  ACCEPTED   = 2
  REJECTED   = 3
  ENDED      = 4
  NOTRESPONDED      = 5

end
