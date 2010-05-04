class ForgotPassword < ActionMailer::Base
  
  def index_notification(recipient, host)
    recipients 
    subject "Восстановление пароля"
    default_url_options[:host] = host
    part :content_type => "text/html", :body => render_message('index', :user => recipient)
  end
end
