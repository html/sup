class Event < ActiveRecord::Base
  validates_presence_of :title, :content, :start_time, :place_id, :subject_id, :event_type, :owner_id
  validates_numericality_of :cost, :allow_blank => true, :allow_nil => true
  validates_length_of :title, :maximum => 150
  belongs_to :place 
  belongs_to :subject
  belongs_to :event_type
  belongs_to :owner

  has_attached_file :image, :default_url => '/images/no_image.jpg', :styles => {
    :list => "330x190#"
  }
  #validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']

  def self.last_event_date
    item = first(:order => 'start_time DESC')
    item && item.start_time
  end

  def self.all_in_range(from, till, page = 1)
    paginate(
       :per_page => 5, 
       :page => page, 
       :conditions => ['start_time >= ? AND start_time <= ?', from, till], 
       :order => 'start_time DESC, id DESC'
    )
  end

  #XXX Do not rename variables
  def self.search(page = nil, subject_parent_id = nil, subject_id = nil, event_type_id = nil, place_parent_id = nil, place_id = nil, free = nil, starting_from = nil, ending_at = nil)
    data = self.id_gt(0)

    %w(subject_parent_id subject_id event_type_id place_parent_id place_id).each do |item|
      value = eval(item)

      if value && !value.zero?
        data = data.send("#{item}_equals", value)
      end
    end

    if free && !free.zero?
      if free == 1
        data = data.cost_blank_or_cost_equals(0)
      else
        data = data.cost_gt(0)
      end
    end

    if starting_from
      data = data.start_time_gt(starting_from)
    end

    if ending_at
      data = data.start_time_lt(ending_at)
    end

    data.paginate :per_page => 5, :page => page || 1
  end
end
