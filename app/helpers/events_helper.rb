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
end
