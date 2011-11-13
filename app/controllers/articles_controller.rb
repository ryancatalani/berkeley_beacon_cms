class ArticlesController < ApplicationController
	def new
		@article = Article.new
	end
	
	def create
		p = params[:article]
		p[:articletype] = params[:articletype].to_i
		@article = Article.new(p)
		if @article.save
			redirect_to articles_url, :notice => "Article posted!"
		else
			render "new"
		end
	end
	
	def index
		@articles = Article.all
	end

end
