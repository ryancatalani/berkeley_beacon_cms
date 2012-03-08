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
		logger.debug "fs = #{@featured_stories.count}"
		@middle_stories = find_tag_articles "Middle Strip Story" #should be 4 eventually
		@news = find_section_articles "News"
		@opinion = find_section_articles "Opinion", 2
		@ae = find_section_articles "Arts & Entertainment"
		@lifestyle = find_section_articles "Lifestyle"
		@sports = find_section_articles "Sports"
		@popular = popular_articles
		
		@home_header = true
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
		@include_custom_bootstrap = true
	end

	def beacon_ecla_tweets
		@results = Twitter.search("from:magicofpi OR from:AlexCKaufman OR from:heidimoeller", :rpp => 5, :result_type => "recent")
		render :json => @results
	end

	def all_ecla_tweets
		@results = Twitter.search("#emersonla OR #ecla", :rpp => 5, :result_type => "recent")
		render :json => @results
		# respond_to do |f|
		# 	format.json { render :json => @results }
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

		def find_section_articles(section_name,number_of_articles=3)
			Section.find_by_name(section_name).articles.order("created_at DESC").first(number_of_articles)
		end

end
