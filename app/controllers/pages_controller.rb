require 'will_paginate/array'

class PagesController < ApplicationController
	def home
		@current_user = current_user
		@main_story = find_tag_articles("Main Story", 1).pop
		@featured_stories = find_tag_articles "Featured Story"
		# fs = @featured_stories.map {|s| s.mediafiles.count >= 1 }.count(false)
		# unless fs.zero?
		# 	@featured_stories << find_more_tag_articles("Featured Story", fs)
		# 	@featured_stories.flatten!
		# end
		@section_first_stories = Section.order("name ASC").map {|s| s.articles.order("created_at DESC").first }
		@middle_stories = find_tag_articles "Middle Strip Story", 5
		@news = find_section_articles "News"
		@opinion = find_section_articles "Opinion", 2
		@ae = find_section_articles "Arts"
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
		index_name = Rails.env.production? ? "idx_production" : "idx"
		client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'] || 'http://:y1GqHmgP0jH2lL@dphiu.api.searchify.com')
		index = client.indexes(index_name)
		results = index.search(params[:q])
		@articles = results['results'].map{|r| r['docid']}.map{|id| Article.find(id.to_i)}.paginate(:page => params[:page], :per_page => 15)
	end

	def tweet

	end

	def apply
		@title = "Join the Beacon"
		@new_header = true
		@og ||= {}
		@og[:title] = "Our new voice"
		@og[:url] = "http://berkeleybeacon.com/apply"
		@og[:image] = "http://berkeleybeacon.com/assets/redesign-promo-#{Random.rand(4)+1}-thumb.jpg"
		@og[:description] = "Pick up the completely redesigned Berkeley Beacon this Thursday."
		render :layout => 'new_header'
	end

	def videos
		@body_id = "video_page"
		@videos = Mediafile.where(:mediatype => 2).order("created_at DESC").reject{|m| m.articles.count.zero? }
	end
	
	private
		def find_tag_articles(tag_name,number_of_articles=3)
		  Tagging.where(:tag_id => Tag.find_by_name(tag_name).id).order("created_at DESC").limit(number_of_articles).map{|t| t.article}
      # Tag.find_by_name(tag_name).articles.order("created_at DESC").first(number_of_articles)
		end

		def find_more_tag_articles(tag_name,number_of_articles=3)
			Tagging.where(:tag_id => Tag.find_by_name(tag_name).id).order("created_at DESC").limit(number_of_articles).offset(3).map{|t| t.article}
		end

		def find_section_articles(section_name,number_of_articles=3)
			Section.find_by_name(section_name).non_blog_articles.order("created_at DESC").first(number_of_articles)
		end

end
