class SectionsController < ApplicationController
	# before_filter :gohome
	# caches_action :show

	def show
		@include_responsive = true
		begin
			section = Section.find_by_clean_url params[:name]
			@sname = section.name
			@articles = section.articles.paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
		rescue
			redirect_to root_path
		end
	end

	def api_list_by_slug
		begin
			section = Section.find_by_clean_url params[:slug]
			articles = Article.where(:issue_id => Issue.latest.id, :section_id => section.id, :draft => false).all
			render json: api_wrangle_articles(articles)
		rescue
			render json: []
		end
	end
	
	private
		def gohome
			redirect_to root_path
		end

end
