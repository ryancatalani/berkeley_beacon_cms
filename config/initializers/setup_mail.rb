ActionMailer::Base.smtp_settings = {
  :address              => "smtp.mailgun.org",
  :port                 => 587,
  :domain               => "app1905056.mailgun.org",
  :user_name            => "postmaster@app1905056.mailgun.org",
  :password             => "EMERSON2011",
  :authentication       => "plain",
  :enable_starttls_auto => true
}