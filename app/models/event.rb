class Event < ActiveRecord::Base
  validates_presence_of :title, :content, :start_time, :place_id, :subject_id, :event_type
  validates_numericality_of :cost, :allow_blank => true, :allow_nil => true
  validates_length_of :title, :maximum => 150
  belongs_to :place 
  belongs_to :subject
  belongs_to :event_type
  has_attached_file :image, :default_url => '/images/no_image.jpg', :styles => {
    :list => "330x190#"
  }
  #validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']

  def self.last_event_date
    item = first(:order => 'start_time DESC')
    item && item.start_time
  end
end
