class ForgotPassword < ActionMailer::Base
  
  def index_notification(recipient)
    from "i@soulup.net"
    recipients recipient.email_address_with_name
    subject "Восстановление пароля"
    part :content_type => "text/html", :body => render_message('index', :user => recipient)
  end
end
