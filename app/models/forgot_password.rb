class ForgotPassword < ActionMailer::Base
  
  def index_notification(recipient, host)
    recipients recipient.email_address_with_name
    subject "Восстановление пароля"
    default_url_options[:host] = host
    part :content_type => "text/html", :body => render_message('index', :user => recipient)
  end
end
