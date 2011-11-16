class ArticlesController < ApplicationController
	before_filter :check_editor
	
	def new
		@article = Article.new
		@authors = Person.all.map {|person| [person.name, person.id]}
	end
	
	def create
		p = params[:article]
		p[:articletype] = params[:articletype].to_i
		begin
			author = Person.find(params[:author_1])
		rescue
			author = current_user
		end
		@article = Article.new(p)
		
		if @article.save
			authorship = Authorship.create!(:article_id => @article.id, :person_id => author.id)
			redirect_to articles_url, :notice => "Article posted!"
		else
			@authors = Person.all.map {|person| [person.name, person.id]}
			render "new"
		end
	end
	
	def index
		@articles = Article.all
	end
	
end
