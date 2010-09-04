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

  def require_jquery
    # jquery already included
  end

  def require_jquery_datepicker
    stylesheet '/css/base/ui.all.css'
    javascript 'ui/ui.core', 'ui/ui.datepicker', 'ui/i18n/ui.datepicker-ru'
  end

  def require_jquery_selectchain
    javascript 'jquery.selectchain', 'apply-select-chain'
  end

  def require_jquery_tooltip
    require_jquery
    stylesheet 'jquery.tooltip'
    javascript 'jquery.tooltip'
  end

  def require_tooltips
    content_for :head do
      render :partial => '/tooltips'
    end
  end

  def display_place_for(user)
    if user.place
      if user.place.parent
        h "#{user.place.parent.title}, #{user.place.title}"
      else
        h "#{user.place.title}"
      end
    else
      'неизвестно'
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

  def avatar_for(user)
    image_tag user.avatar.url, :class => 'avatar', :width => 150, :height => 150
  end
end
