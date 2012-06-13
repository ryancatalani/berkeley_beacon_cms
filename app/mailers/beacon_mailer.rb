class BeaconMailer < ActionMailer::Base
  default from: "The Berkeley Beacon Robot <postmaster@app1905056.mailgun.org>"

  	def reset_password_2012(name, email, password)
  		@name, @email, @password = name, email, password
  		mail(:to => email, :subject => "[The Berkeley Beacon] Password Reset")
  	end

	def tip(body, name, contact)
		@the_body = body
		@name = name
		@contact = contact
		mail(:to => "heidi.e.moeller@gmail.com", :subject => "[Beacon] New Tip")
	end

	def archive_problem(url)
		@url = url
		mail(:to => "catalani.ryan@gmail.com", :subject => "[Beacon] Archive Problem")
	end
end
