# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def pagination_for(items)
    render :partial => '/pagination', :locals => { :items => items }
  end
end
