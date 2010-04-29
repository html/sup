# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def pagination_for(items)
    render :partial => '/pagination', :locals => { :items => items }
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def require_jquery_datepicker
    stylesheet '/css/base/ui.all.css'
    javascript 'ui/ui.core', 'ui/ui.datepicker', 'ui/i18n/ui.datepicker-ru'
  end
end
