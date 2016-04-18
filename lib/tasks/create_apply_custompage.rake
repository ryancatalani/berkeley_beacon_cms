namespace :db do
	desc "Create apply page as CustomPage"
	task :create_apply_custom_page => :environment do

		title = "Apply"
		slug = "apply"
		content = '<div id="full_photo"><div id="ourvoice_text" class="right"><p>What’s your Beat?<br>Find it with the Beacon.</p><p class="apply_small">Applications for <a href="/about">any staff position</a> in the fall 2015 semester are due on Sunday, April 5. Interviews will be held on Monday, April 6.</p><p class="apply_small">Print your application and drop it off in our mailbox at the lower level campus center of Piano Row, or email it to <a href="mailto:editor@berkeleybeacon.com">editor@berkeleybeacon.com</a>.</p><p class="apply_small"><a href="http://theberkeleybeacon.s3.amazonaws.com/BeaconStaffApplication1415.doc">Click here to download the application.</a></p></div></div><script type="text/javascript">$("#full_photo").anystretch("/assets/apply_big.jpg");$("#ourvoice_text").addClass( num % 2 == 0 ? "left" : "right" );</script>'

		CustomPage.create! title: title, slug: slug, content: content

	end
end