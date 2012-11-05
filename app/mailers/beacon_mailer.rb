class BeaconMailer < ActionMailer::Base
  default :from => "The Berkeley Beacon <postmaster@app1905056.mailgun.org>",
  	:reply_to => "The Berkeley Beacon <contact@berkeleybeacon.com>"

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

	def confirm_political_poll(email, email_hash, code)
		@link = "http://berkeleybeacon.com/political_poll/confirm?e=#{email_hash}&c=#{code}"
		mail(:to => email, :subject => "Confirm your response - Emerson College Political Poll")
	end

	def just_posted(posts,titles)
		@posts = posts
		mail(:to => "catalani.ryan@gmail.com", :subject => "[Beacon] Just posted")
	end
end
