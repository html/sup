class Post < ActiveRecord::Base
  has_attached_file :image, :default_url => '/images/no_image.jpg'
  validates_presence_of :title, :content, :image, :date
end
