# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'I18n'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :current_user
  include SimpleCaptcha::ControllerHelpers  

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
    def assign_places
      @places = Place.roots
    end

    def assign_subjects
      @subjects = Subject.roots
    end

    def current_user
      @current_user ||= TypusUser.find_by_id session[:typus_user_id]
    end

    def require_login
      unless @current_user
        flash[:notice] = render_to_string '/require_login'
        return redirect_to :back if request.env['HTTP_REFERER']
        return redirect_to root_url
      end

      require_activation
    end

    def require_activation
      unless @current_user && @current_user.activated?
        flash[:notice] = render_to_string '/require_activation'
        return redirect_to :back if request.env['HTTP_REFERER']
        return redirect_to root_url
      end
    end

    def forbidden
      raise "Forbidden"
    end

    def parse_date(date)
      Date.strptime(date, '%d.%m.%Y')
    rescue
      Date.parse(date)
    end

    def _(a, b= {})
      I18n.t(a, b)
    end

    def redirect_back_or(path)
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to path
    end
end
