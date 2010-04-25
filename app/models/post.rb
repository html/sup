class Post < ActiveRecord::Base
  has_attached_file :image, :default_url => '/images/no_image.jpg'
  validates_presence_of :title, :content, :image, :date

  def self.list(page = 1)
    paginate :page => page || 1, :per_page => 5, :order => 'date DESC'
  end
end
