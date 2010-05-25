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

  def require_jquery_selectchain
    javascript 'jquery.selectchain', 'apply-select-chain'
  end

  def display_place_for(user)
    if user.city
      if user.city.parent
        h "#{user.city.parent.title}, #{user.city.title}"
      else
        h "#{user.city.title}"
      end
    end
  end

  def display_age_for(birthdate, today = Date.today)
    return nil if birthdate.nil? || birthdate > today
    if today.month >= birthdate.month and today.day >= birthdate.day 
      # Birthday has happened already this year.
      today.year - birthdate.year
    else
      today.year - birthdate.year - 1
    end
  end

  def t(a, b= {})
    I18n.t(a, b)
  end
end
