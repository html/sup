class Video < ActiveRecord::Base
  has_one :material, :as => :item
  has_many :materials, :as => :item
  
  def list_representation
    code
  end
end
