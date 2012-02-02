class BeaconMailer < ActionMailer::Base
  default from: "The Berkeley Beacon Robot <postmaster@app1905056.mailgun.org>"

	def tip(body, name, contact)
		@the_body = body
		@name = name
		@contact = contact
		mail(:to => "alexanderckaufman@gmail.com", :subject => "[Beacon] New Tip")
	end
end
