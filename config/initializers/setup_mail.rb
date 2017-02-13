ActionMailer::Base.smtp_settings = {
  :address              => "smtp.sendgrid.net",
  :port                 => 587,
  :domain               => "berkeleybeacon.com",
  :user_name            => "***REMOVED***",
  :password             => "***REMOVED***",
  :authentication       => "plain",
  :enable_starttls_auto => true
}