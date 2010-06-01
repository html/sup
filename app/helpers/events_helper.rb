module EventsHelper
  def display_cost_for(item)
    item.cost && !item.cost.zero? ? item.cost : 'Бесплатное посещение'
  end

  def date_for(item)
    if item.start_time

      if item.end_time.nil? || item.start_time == item.end_time
        l item.start_time, :format => "%d %B %Y года"
      else
        if item.start_time.month == item.end_time.month
          "#{l item.start_time, :format => "%d"} - #{l item.end_time, :format => "%d %B %Y года"}"
        else
          "#{l item.start_time, :format => "%d %B"} - #{l item.end_time, :format => "%d %B %Y года"}"
        end
      end
    end
  end

  def place_for(item)
    if item.place
      h item.place.title
    else
      'неизвестно'
    end
  end

  def events_root_place
    if @root_place_id
      @child_places = Place.parent_id_equals(@root_place_id).collect { |item| [item.title, item.id] }
    end

    select :events, :root_place, @places.collect { |p| [p.title, p.id] }, :include_blank => "Любая страна", :selected => @root_place_id
  end

  def events_root_subject
    if @root_subject_id
      @child_subjects = Subject.parent_id_equals(@root_subject_id).collect { |item| [item.title, item.id] }
    end

    select :events, :root_subject, @subjects.collect { |p| [p.title, p.id] }, :include_blank => "Любая тематика", :selected => @root_subject_id
  end

  def formatted_date_for_edit_field(date)
    date && date.strftime('%d.%m.%Y')
  end
end
