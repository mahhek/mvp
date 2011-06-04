class Notifier < ActionMailer::Base
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "Binary Logic Notifier "
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def activation_instructions(user)
    from          "GoneRenting <noreply@gonerenting.com>"

    @account_activation_url = activate_account_url(user.perishable_token)

    subject       "Activation Instructions"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => activate_account_url(user.perishable_token)
    content_type  "text/html"


  end
  
  def activation_confirmation(user)
    from          "GoneRenting <noreply@gonerenting.com>"
    subject       "Activation Confirmation"
    recipients    user.email
    sent_on       Time.now
    content_type "text/html"

  end

  def forgot_password(user)

    subject       "Password Reset Instructions"
    from          "GoneRenting <noreply@gonerenting.com>"
    recipients    user.email
    sent_on       Time.now
    body          :reset_password_link => reset_password_url(user.perishable_token)
  end

end
