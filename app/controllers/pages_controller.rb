class PagesController < ApplicationController
	def home
		@current_user = current_user
		
		@main_story = find_tag_articles("Main Story", 1).pop
		@featured_stories = find_tag_articles "Featured Story"
		@middle_stories = find_tag_articles "Middle Strip Story" #should be 4 eventually
		@news = find_section_articles "News"
		@opinion = find_section_articles "Opinion", 2
		@ae = find_section_articles "Arts & Entertainment"
		@lifestyle = find_section_articles "Lifestyle"
		@sports = find_section_articles "Sports"
		@popular = popular_articles
		
		@home_header = true
	end

	def about
	end
	
	private
		def find_tag_articles(tag_name,number_of_articles=3)
			Tag.find_by_name(tag_name).articles.order("created_at DESC").first(number_of_articles)
		end
		
		def find_section_articles(section_name,number_of_articles=3)
			Section.find_by_name(section_name).articles.order("created_at DESC").first(number_of_articles)
		end

end
