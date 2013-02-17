namespace :db do
	desc "Add existing go routes"
	task :add_go_routes => :environment do

		routes = [
			['beacon-beat', "http://berkeleybeacon.com/news/2013/2/14/the-beacon-beat-february-14-2013"],
			['police', "http://www.berkeleybeacon.com/multimedia/2012/9/6/an-interview-with-the-new-police-chief"],
			['scaffolding', "http://www.berkeleybeacon.com/multimedia/2012/9/6/students-react-to-the-little-building-scaffolding-art"],
			['ols', "http://www.berkeleybeacon.com/multimedia/2012/9/6/meet-the-orientation-leader-core-staff"],
			['fashion-night-out', "http://www.berkeleybeacon.com/lifestyle/2012/9/13/fashion-night-out"],
			['print-copy', "http://www.berkeleybeacon.com/news/2012/9/13/print-and-copy-center-finds-new-home"],
			['leap', "http://berkeleybeacon.com/lifestyle/2012/9/20/emerson-women-leap-to-teach-selfdefense"],
			['soccer', "http://www.berkeleybeacon.com/multimedia"],
			['magician', "http://www.berkeleybeacon.com/multimedia/2012/9/27/emerson-mane-events-brings-magic-to-campus"],
			['collegefest', "http://berkeleybeacon.com/lifestyle/2012/9/27/students-enjoy-swag-and-songs-at-collegefest-2012"],
			['quinnterviews', "http://www.berkeleybeacon.com/news/2012/10/4/quinnterviews-picked-up-by-mtvu"],
			['sexapalooza', "http://www.berkeleybeacon.com/lifestyle/2012/10/4/sexapalooza-education-and-lubrication"],
			['womens-soccer', "http://www.berkeleybeacon.com/sports/2012/10/11/emerson-crucified-by-saints"],
			['lb-maintenance', "http://www.berkeleybeacon.com/news/2012/10/11/little-building-construction-continues"],
			['cleaning', "http://berkeleybeacon.com/lifestyle/2012/10/18/christian-students-offer-cleaning-services"],
			['mens-soccer', "http://berkeleybeacon.com/sports/2012/10/18/determined-defensive-display"],
			['marchingband', "http://www.berkeleybeacon.com/lifestyle/2012/10/25/students-march-to-a-bc-beat"],
			['womens-tennis', "http://www.berkeleybeacon.com/sports/2012/10/25/duo-shines-in-gnac-finale"],
			['gregpayne', "http://berkeleybeacon.com/news/2012/11/1/political-insert-gregory-payne"],
			['feminist-panel', "http://www.berkeleybeacon.com/lifestyle/2012/11/8/feminist-panel-hopes-to-stomp-out-stereotypes?n=go"],
			['engagement-lab', "http://www.berkeleybeacon.com/news/2012/11/8/the-engagement-game-lab-relocates?n=go"],
			['lb-art-installation', "http://berkeleybeacon.com/lifestyle/2012/11/15/mag-to-choose-new-scaffolding-artist"],
			['maxine-renning', "http://berkeleybeacon.com/lifestyle/2012/11/29/friends-share-a-bonedeep-bond"],
			['battleofthebands', "/"],
			['notebook', "http://berkeleybeacon.com/multimedia/2012/12/6/the-notebook"],
			['reactions-to-5', "http://berkeleybeacon.com/arts/2012/12/6/rockettes-and-zombies-edc-graces-the-stage"],
			['pelton-initiative', "http://berkeleybeacon.com/news/2013/1/17/college-pres-talks-gun-control"],
			['morgan-podcast', "http://berkeleybeacon.com/opinion/2013/1/24/sticks-and-stones-words-hurt"],
			['canvas-tutorial', "http://berkeleybeacon.com/news/2013/1/24/students-and-faculty-welcome-new-learning-management-system"],
			['kristin-brice', "http://berkeleybeacon.com/sports/2013/1/31/sophomore-emerges-as-star-of-womens-basketball"],
			['mane-events', "http://berkeleybeacon.com/news/2013/1/31/poetry-project-granted-392380"],
			['poetry-project', "http://berkeleybeacon.com/lifestyle/2013/1/31/emerson-mane-events-hosts-headphone-disco"],
			['valentines-day-pie', "http://berkeleybeacon.com/lifestyle/2013/2/7/valentines-sweetiepie"],
			['rhodes-carbone', "http://berkeleybeacon.com/sports/2013/2/7/rhodes-and-carbone-add-to-emerson-offensive-attack"],
			['graffiti', "http://berkeleybeacon.com/news/2013/2/14/vandalism-found-on-and-inside-dormitory-elevator"],
			['Nemo-fun', "http://berkeleybeacon.com/multimedia/2013/2/14/students-enjoy-nemos-snow"]
		]

		routes.each do |route|
			ShortLink.create!(:prefix => 'go', :link_text => route[0], :destination => route[1])
		end

	end
end