require 'will_paginate/array'

class PagesController < ApplicationController
	before_filter :check_editor, :only => [:new_editorial_cartoon, :campus_data, :year_in_review_2014, :title_ix]

	def home
		@current_user = current_user

		layout = HomeLayout.last
		@main_story = Article.find(layout.articles[:lead]) rescue nil
		@featured_stories = layout.articles[:featured].map{ |id| Article.find(id) rescue next }
		@middle_stories = layout.articles[:middle].map{|id| Article.find(id) rescue next }

		@main_story_photo = layout.articles[:should_use_photo][:lead]
		@main_story_is_standalone_photo = layout.articles[:lead_is_standalone_photo]
		@featured_stories_photos = layout.articles[:should_use_photo][:featured]
		@middle_stories_photos = layout.articles[:should_use_photo][:middle]

		@news = find_section_articles "News"
		@opinion = find_section_articles "Opinion"
		@arts = find_section_articles "Arts"
		@lifestyle = find_section_articles "Lifestyle"
		@sports = find_section_articles "Sports"
		@popular = popular_articles
		@home_header = true
		@include_responsive = true
		@blogs = Blog.all
		@latest_multimedia = Mediafile.where(mediatype: 2).joins(:articles).where(articles: {draft: false}).order("created_at DESC").first(3)
		@latest_issue = Issue.latest

		@latest_issue_events = Article.where(:issue_id => Issue.latest, :section_id => Section.find_by_name('Events').id) rescue []
		@og ||= {}
		@og[:description] = "Emerson College's independent student newspaper"
	end

	def static_home
		render :layout => false
	end

	def tips
		@title = "Send a tip"
		@include_bootstrap = true
	end

	def send_tip
		BeaconMailer.tip(params[:body],params[:name],params[:contact]).deliver
		redirect_to root_path
	end

	def about
		@title = "About"
		@include_bootstrap = true
		about = About.last
		@col1 = about.col1
		@col2 = about.col2
		@col3 = about.col3
	end

	def oscars
		@title = "Oscar Predictions"
		@include_bootstrap = true
	end

	def oscars2013
		@title = "2013 Oscar Predictions"
		@include_bootstrap = true
		@needs_og = true
		@og = {}
		@og[:title] = "The Beacon's Oscar picks"
		@og[:url] = "http://berkeleybeacon.com/oscars"
		@og[:image] = "http://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/zero_web_thumb.jpg"
		@og[:description] = "See the films that Beacon staff members think should win Academy Awards."
	end

	def oscars2014
		@title = "The Beacon's 2014 Oscar Picks"
		@needs_og = true
		@include_responsive = true
		@og = {}
		@og[:title] = "The Beacon's Oscar picks"
		@og[:url] = "http://berkeleybeacon.com/oscars"
		@og[:image] = ActionController::Base.helpers.asset_path('oscars-ejiofor.jpg')
		@og[:description] = "See the films that Beacon staff members think should win Academy Awards."
	end

	def ecla
		@title = "Special Feature: Emerson College LA"
		@include_bootstrap = true
		@include_gmaps = true
		@articles = Series.find_by_title("ECLA").articles.where(:articletype => 1) rescue nil
		@media = Series.find_by_title("ECLA").articles.where("articletype <> 1") rescue nil
		begin
			@tweets = Twitter.search("#emersonla", :rpp => 10, :result_type => "recent")
		rescue
			@tweets = []
		end
		@quote = Series.find_by_title("ECLA Quote").articles.first rescue nil
	end

	def emersonla_live
		@title = "Emerson Colllege LA Groundbreaking Live"
		@include_bootstrap = true
	end

	def beacon_ecla_tweets
		# if params[:last_id]
		# 	last_tweet = EclaAnyTweet.find_by_tweet_id(params[:last_id].to_i)
		# 	if !last_tweet.nil?
		# 		later_tweets = EclaAnyTweet.where("created_at > ?",last_tweet.created_at)
		# 		if !later_tweets.nil?
		# 			@results = later_tweets
		# 			found_tweets = true
		# 		end
		# 	end
		# end

		# unless found_tweets
		# 	tweets.map do |tweet|
		# 		EclaAnyTweet.create!(tweet_id => )

		@results = Twitter.search("#emersonla OR #ecla from:magicofpi OR from:AlexCKaufman OR from:heidimoeller", :rpp => 5, :result_type => "recent")
		render :json => @results
	end

	def all_ecla_tweets
		@results = Twitter.search("#emersonla OR #ecla", :rpp => 5, :result_type => "recent")
		render :json => @results
		# respond_to do |f|
		# 	format.json { render :json => @results }
		# end
	end

	def archive_problem
		BeaconMailer.archive_problem(params[:url]).deliver
		render :json => "mail sent"
	end

	def ourvoice
		@new_header = true
		@title = "Our new voice"
		@needs_og = true
		@og = {}
		@og[:title] = "Our new voice"
		@og[:url] = "http://berkeleybeacon.com/ourvoice"
		@og[:image] = ActionController::Base.helpers.asset_path("redesign-promo-#{Random.rand(4)+1}-thumb.jpg")
		@og[:description] = "Pick up the completely redesigned Berkeley Beacon this Thursday."
		render :layout => 'new_header'
	end

	def search
		@title = "Search results: #{params[:q]}"
		if params[:q]
			order = params[:order] || 'relevance'
			article_response = Article.search_public(params[:q], order)
			@articles = article_response.page(params[:page]).records
			@articles_total = article_response.results.total
			mediafile_response = Mediafile.search(params[:q])
			@mediafiles = mediafile_response.records
			people_response = Person.search(params[:q])
			@people = people_response.records

			# @articles_time_series = search_time_series(article_response.records) if @articles.any?

			@no_results = !@articles.any? && !@mediafiles.any? && !@people.any?
		else
			@articles = []
			@mediafiles = []
			@people = []
		end
	end

	def search_frontend
		@title = "Search"
		@include_responsive = true
		@no_bootstrap = true
	end

	def tweet

	end

	def apply
		@title = "Join the Beacon"
		@new_header = true
		@needs_og = true
		@og ||= {}
		@og[:title] = "Join the Beacon"
		@og[:image] = ActionController::Base.helpers.asset_path("apply_small.jpg")
		@og[:description] = "What's your beat? Find it with the Beacon. Applications for staff positions are due on Friday, April 19."
		@applications_open = true
		render :layout => 'new_header'
	end

	def videos
		@body_id = "video_page"
		@videos = Mediafile.where(:mediatype => 2).order("created_at DESC").reject{|m| m.articles.count.zero? }
	end

	def election_guide_2012
		@og = {}
		@og[:title] = "Beacon Election Guide 2012"
		@og[:image] = "http://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/election_guide_thumb.jpg"
		@og[:description] = "A special political section with op-eds, the Beacon's poll results, and more."
	end

	def political_poll_results
		@og = {}
		@og[:title] = "Poll Results | Beacon Election Guide 2012"
		@og[:image] = "http://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/poll_thumb_460.jpg"
		@og[:description] = "See how Emerson students stand on election issues."
	end

	def election_map
		@og = {}
		@og[:title] = "Voting Locations | Beacon Election Guide 2012"
		@og[:image] = "http://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/voting%20map-01-thumb.jpg"
		@og[:description] = "See voting locations around Boston, and how to find out where to vote."
	end

	def find_voting_location

		# final_voting_address = ''

		# # Check maps API
		# address = URI.encode "80 Boylston St. 02116"
		# uri = URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{address}&sensor=false")
		# http = Net::HTTP.new(uri.host, uri.port)
		# request = Net::HTTP::Get.new(uri.request_uri)
		# request["Content-Type"] = "application/json"
		# response = http.request(request)
		# maps_json = ActiveSupport::JSON.decode(response.body)
		# maps_json_results = maps_json["results"]

		# if maps_json_results.count > 1
		# 	final_voting_address = maps_json_results.first["formatted_address"]
		# else
		# 	maps_json_results.each do |r|
		# 		r["formatted_address"]
		# 	end
		# end

	end

	def statusboard_top_5_json
		@results = PopularSnapshot.statusboard_top_5
		render :json => @results
	end

	def emersonla
		@body_id = "emersonla"
		@include_responsive = true
		@title = "Emerson LA: Special Coverage"
		@og ||= {}
		@og[:description] = "Articles, photos, and videos with an in-depth look at the new Emerson Los Angeles in Hollywood."
		@og[:image] = "https://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/thumb_460_1389855659-LALeadArt1_Catalani_forweb.jpg.jpg"

		@sc = SpecialCoverage.find_by_title("Emerson LA")
		@lead = Article.find(@sc.lead) rescue nil
		@featured = @sc.featured.map{|id| Article.find(id)} rescue nil
		@related_t = Topic.find(@sc.related_topic) rescue nil
		@related_a = @sc.related_articles.map{|id| Article.find(id)} rescue nil
		@updates = @sc.updates.reverse rescue []
		@media = @sc.media.map{|id| Mediafile.find(id)} rescue nil

		render :layout => 'bare'
	end

	def emersonla_videos
		@body_id = "emersonla_videos"
		@include_responsive = true
		@use_roboto = true
		@use_videojs = true
		@title = "Emerson LA: Stories"
		@og ||= {}
		@og[:description] = "Videos about Emerson's new campus and community in Hollywood."
		@og[:image] = "http://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/ela_videos_cover.jpg"

		render :layout => 'bare'
	end

	def commencement2014
		@body_id = "commencement2014"
		@include_responsive = true
		@title = "Commencement 2014: Special Coverage"
		@og ||= {}
		@og[:description] = "Liveblog, articles, and photos, with an in-depth look at Emerson's 134th commencement."

		@sc = SpecialCoverage.find_by_title("Commencement 2014")
		@lead = Article.find(@sc.lead) rescue nil
		@featured = @sc.featured.map{|id| Article.find(id)} rescue nil
		@related_t = Topic.find(@sc.related_topic) rescue nil
		@related_a = @sc.related_articles.map{|id| Article.find(id)} rescue nil
		@updates = @sc.updates.reverse rescue []
		@media = @sc.media.map{|id| Mediafile.find(id)} rescue nil

		render :layout => 'bare'
	end

	def campus_data
	end

	def year_in_review_2014
		@body_id = "review2014"
		@include_responsive = true
		@title = "Year in Review 2014"
		@og ||= {}
		@og[:description] = "An in-depth look at the stories that shaped the year at Emerson."

		render :layout => 'bare'
	end

	def race_at_emerson
		@body_id = "raceseries"
		@include_responsive = true
		@title = "A half-century of race relations at Emerson"
		@og ||= {}
		@og[:description] = "An in-depth look at the protests, tenure controversies, administrators, and admissions policies that continue to shape race relations."
		@og[:image] = "http://theberkeleybeacon.s3.amazonaws.com/race_intro.jpg"

		render :layout => 'bare'
	end

	def snow_calculator
		@body_id = "snow_calculator"
		@include_responsive = true
		@title = "How much are your missed classes worth?"
		@no_bootstrap = true
		@og ||= {}
		@og[:description] = "Emerson has canceled several days of classes because of the snow. See how much your missed classes are worth."
		@og[:image] = "https://s3.amazonaws.com/BerkeleyBeacon/beacon_uploads/uploads/1423126348-Snowstorm_Bushell_01272015_0021.jpg.jpg"
	end

	def oscars2015
		@body_id = "oscars2015"
		@include_responsive = true
		@title = "The Beacon's 2015 Oscar Picks"
		@og ||= {}
		@og[:description] = "See the films that Beacon staff members think should win Academy Awards."
		@og[:image] = "http://theberkeleybeacon.s3.amazonaws.com/oscars2015/oscars_preview.jpg"
	end

	def website1997
		@body_id = "website1997"
		@title = "The Beacon's website in 1997"
		@og ||= {}
		@og[:description] = "This was the Beacon's website in 1997, a time when “online” was still hyphenated and zany Photoshop effects were prized."
		@og[:image] = "http://theberkeleybeacon.s3.amazonaws.com/beacon_website_1997.gif"
	end

	def title_ix
		@body_id = "title_ix"
		@title = "Title IX disputes at Emerson"
		@include_responsive = true
	end

	def neighborhoods2015
		@body_id = "neighborhoods2015"
		@title = "Housing in Boston"
		@include_responsive = true
		@og ||= {}
		@og[:description] = "Special series: Learn about different Boston-area neighborhoods each week."
		@og[:image] = "http://theberkeleybeacon.s3.amazonaws.com/housing_thumb.jpg"
	end

	def weekly_newsletter
		@body_id = "weekly_newsletter"
		@title = "Beacon Weekly Newsletter"
		@include_responsive = true
		@no_bootstrap = true
		@og ||= {}
		@og[:description] = "Sign up for the Beacon's weekly newsletter that recaps each issue's top stories."
		@og[:image] = "http://theberkeleybeacon.s3.amazonaws.com/newsletter_preview_fb.jpg"
	end

	def adjunct_calculator
		@body_id = "adjunct_calculator"
		@title = "Calculate how much your adjunct professors earn."
		@no_bootstrap = true
		@include_responsive = true
		@og ||= {}
		@og[:description] = "Enter your classes and see how much your professors are paid."
		@og[:image] = "http://theberkeleybeacon.s3.amazonaws.com/beacon_1000x1000.jpg"
	end

	def climate_survey
		@body_id = "climate_survey"
		@title = "Surveying Emerson's Climate"
		@no_bootstrap = true
		@include_responsive = true
		@og ||= {}
		@og[:description] = "Explore the results from Emerson's first comprehensive climate survey."
		@og[:image] = "http://theberkeleybeacon.s3.amazonaws.com/climate-survey/climatesurveyhead_web.jpg"
		render :layout => 'bare'
	end

	def review_2014_2015
		@body_id = "review_2014_2015"
		@title = "2014–2015: A school year in review"
		@no_bootstrap = true
		@include_responsive = true
		@og ||= {}
		@og[:description] = "A look back at the news and trends that shaped this school year."
		@og[:image] = "http://theberkeleybeacon.s3.amazonaws.com/yearinreview/yearinreview_social.jpg"
		render :layout => 'bare'
	end

	private
		def find_tag_articles(tag_name,number_of_articles=3)
		  Tagging.where(:tag_id => Tag.find_by_name(tag_name).id).order("created_at DESC").limit(number_of_articles).map{|t| t.article}
      # Tag.find_by_name(tag_name).articles.order("created_at DESC").first(number_of_articles)
		end

		def find_more_tag_articles(tag_name,number_of_articles=3)
			Tagging.where(:tag_id => Tag.find_by_name(tag_name).id).order("created_at DESC").limit(number_of_articles).offset(3).map{|t| t.article}
		end

		def find_section_articles(section_name,number_of_articles=5)
			a = Section.find_by_name(section_name).non_blog_articles.where('created_at >= ?', 1.week.ago).order('created_at desc')
			if a.count.zero?
				a = Section.find_by_name(section_name).non_blog_articles.order('created_at desc')
			end
			return a.first(number_of_articles).partition{|a| !a.visual_mediafiles.empty? }.flatten
		end

		def search_time_series(articles)
			search_start_year = 2005
			current_year = Time.zone.now.year
			current_month = Time.zone.now.month

			time_slots = {}
			labels = []

			(search_start_year..current_year-1).each do |year|
				(1..12).each do |month|
					str = "#{year}-#{'%02d' % month.to_s}"
					time_slots[str] = 0
					labels << "#{Date::MONTHNAMES[month]} #{year}"
				end
			end
			(1..current_month).each do |month|
				str = "#{current_year}-#{'%02d' % month.to_s}"
				time_slots[str] = 0
				labels << "#{Date::MONTHNAMES[month]} #{current_year}"
			end

			articles.map{|a| a.created_at.strftime("%Y-%m")}.each do |d|
				time_slots[d] += 1
			end

			return [time_slots.values, labels]
		end

end
