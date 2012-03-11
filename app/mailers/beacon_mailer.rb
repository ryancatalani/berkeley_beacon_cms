class BeaconMailer < ActionMailer::Base
  default from: "The Berkeley Beacon Robot <postmaster@app1905056.mailgun.org>"

	def tip(body, name, contact)
		@the_body = body
		@name = name
		@contact = contact
		mail(:to => "alexanderckaufman@gmail.com", :subject => "[Beacon] New Tip")
	end

	def archive_problem(url)
		@url = url
		mail(:to => "catalani.ryan@gmail.com", :subject => "[Beacon] Archive Problem")
	end
end
