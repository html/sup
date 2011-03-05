class Notifier < ActionMailer::Base
  def register_notification(recipient)
    recipients recipient.email_address_with_name
    from "noreply@soulup.net"
    subject "Вы успешно зарегистрировались на сайте soulup.net"
    body :account => recipient
  end

  def activation_notification(recipient)
    recipients recipient.email_address_with_name
    from "noreply@soulup.net"
    subject "Активация аккаунта на сайте soulup.net"
    body :account => recipient
  end
end
