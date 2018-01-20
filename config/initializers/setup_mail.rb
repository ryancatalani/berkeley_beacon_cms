ActionMailer::Base.smtp_settings = {
  :address              => "smtp.sendgrid.net",
  :port                 => 587,
  :domain               => "berkeleybeacon.com",
  :user_name            => ENV['SENDGRID_USER'],
  :password             => ENV['SENDGRID_PASSWORD'],
  :authentication       => ENV['SENDGRID_AUTH'],
  :enable_starttls_auto => true
}