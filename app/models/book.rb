class Book < ActiveRecord::Base
  include ActionView::Helpers
  has_one :material, :as => :item
  has_many :materials, :as => :item
  has_attached_file :file
  
  def list_representation
    image_tag file.url
  end
end
