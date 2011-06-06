class Avatar < ActiveRecord::Base
  belongs_to :location

  has_attached_file :photo, :styles => { :small => "150x150>", :medium => "450x300>" },
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => "/:style/:id/:filename"
  # :url  => "/assets/products/:id/:style/:basename.:extension",
  # :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/jpg', 'image/bmp']
end
