class Notifier < ActionMailer::Base
  def register_notification(recipient)
    recipients recipient.email_address_with_name
    from "i@soulup.net"
    subject "Вы успешно зарегистрировались на сайте soulup.net"
    body :account => recipient
    content_type "text/html"
  end

  def activation_notification(recipient)
    recipients recipient.email_address_with_name
    from "i@soulup.net"
    subject "Активация аккаунта на сайте soulup.net"
    body :account => recipient
    content_type "text/html"
  end
end
