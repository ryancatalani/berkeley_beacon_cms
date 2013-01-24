require 'will_paginate/array'

class PagesController < ApplicationController
	before_filter :check_editor, :only => [:new_editorial_cartoon]

	def home
		@current_user = current_user

		begin
			layout = HomeLayout.last
			@main_story = Article.find(layout.articles[:lead])
			@featured_stories = layout.articles[:featured].map{|id| Article.find(id) }
			@middle_stories = layout.articles[:middle].map{|id| Article.find(id) }
		rescue
			@main_story = find_tag_articles("Main Story", 1).pop
			@featured_stories = find_tag_articles "Featured Story"
			@middle_stories = find_tag_articles "Middle Strip Story", 5
		end

		@news = find_section_articles "News"
		@opinion = find_section_articles "Opinion"
		@arts = find_section_articles "Arts"
		@lifestyle = find_section_articles "Lifestyle"
		@sports = find_section_articles "Sports"
		@popular = popular_articles
		@home_header = true
		@include_responsive = true
		number_of_tweets = @main_story.first_photo.nil? ? 1 : 3
		@tweets = Twitter.user_timeline("beaconupdate").first(number_of_tweets) rescue []
		@blogs = Blog.all
		@latest_multimedia = Mediafile.where(:mediatype => 2).last(3).reverse
		begin
			tumblr_latest = Feedzirra::Feed.fetch_and_parse("http://berkeleybeacon.tumblr.com/rss").entries.first
			@tumblr_latest_title = tumblr_latest.title
			@tumblr_latest_summary = tumblr_latest.summary
			@tumblr_latest_url = tumblr_latest.url
		rescue
			@tumblr_latest_title = "Click here to see the latest post."
			@tumblr_latest_url = "http://berkeleybeacon.tumblr.com"
		end
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
	end

	def oscars
		@title = "Oscar Predictions"
		@include_bootstrap = true
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
		@og[:image] = "http://berkeleybeacon.com/assets/redesign-promo-#{Random.rand(4)+1}-thumb.jpg"
		@og[:description] = "Pick up the completely redesigned Berkeley Beacon this Thursday."
		render :layout => 'new_header'
	end

	def search
		@title = "Search results: #{params[:q]}"
		engine_slug = Rails.env.production? ? "berkeleybeacon" : "berkeleybeaconsandbox"
		# engine = Swiftype::Engine.find(engine_slug)
		if params[:q]
			client = Swiftype::Easy.new
			results = client.search(engine_slug, params[:q])
			@articles = results.records['articles'].map{|r| Article.find(r.external_id.to_i) } #.paginate(:page => params[:page], :per_page => 15)
			@mediafiles = results.records['mediafiles'].map{|r| Mediafile.find(r.external_id.to_i) }
		else
			@articles = []
			@mediafiles = []
		end
	end

	def tweet

	end

	def apply
		@title = "Join the Beacon"
		@new_header = true
		@needs_og = true
		@og ||= {}
		@og[:title] = "Join the Beacon"
		@og[:url] = "http://berkeleybeacon.com/apply"
		@og[:image] = "http://berkeleybeacon.com/assets/apply_small.jpg"
		@og[:description] = "Applications for any staff position are due on Thursday, November 29 April 22 at 7 p.m. Download an application here."
		render :layout => 'new_header'
	end

	def videos
		@body_id = "video_page"
		@videos = Mediafile.where(:mediatype => 2).order("created_at DESC").reject{|m| m.articles.count.zero? }
	end

	def new_editorial_cartoon
		@authors = Person.order("firstname ASC").all.map { |person| [person.official_name, person.id] }
		@mediafile = Mediafile.new
		@ed_series = Series.find_by_title("Editorial Cartoons")
	end

	def editorial_cartoons
		s = Series.find_by_title("Editorial Cartoons")
		redirect_to root_path and return if s.nil?
		@include_responsive = true
		@cartoons = s.mediafiles.order("created_at DESC")
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

end
