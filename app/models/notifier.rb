class Notifier < ActionMailer::Base
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "Binary Logic Notifier "
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def activation_instructions(user)
    from          "Storably <noreply@storably.com>"

    @account_activation_url = activate_account_url(user.perishable_token)

    subject       "Activation Instructions"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => activate_account_url(user.perishable_token)
    content_type  "text/html"


  end
  
  def activation_confirmation(user)
    from          "Storably <noreply@storably.com>"
    subject       "Activation Confirmation"
    recipients    user.email
    sent_on       Time.now
    content_type "text/html"

  end

  def forgot_password(user)

    subject       "Password Reset Instructions"
    from          "Storably <noreply@storably.com>"
    recipients    user.email
    sent_on       Time.now
    body          :reset_password_link => "http://#{SITE_URL}/reset_password/#{user.perishable_token}"
      
  end

end
