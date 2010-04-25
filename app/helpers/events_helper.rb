module EventsHelper
  def display_cost_for(item)
    item.cost && !item.cost.zero? ? item.cost : 'Бесплатное посещение'
  end
end
