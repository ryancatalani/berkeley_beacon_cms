class ArticlesController < ApplicationController
	before_filter :check_editor
	
	def new
		@article = Article.new
		@authors = Person.all.map {|person| ["#{person.name} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}", person.id]}
	end
	
	def create
		p = params[:article]
		p[:articletype] = params[:articletype].to_i
		subs = params[:subtitle].nil? ? [] : params[:subtitle].values
		p[:subtitles] = subs
		authors = []
		params[:author].each do |author|
			begin
				authors << Person.find(author)
			rescue
			end
		end
		logger.debug("authors = #{authors}")
		@article = Article.new(p)
		
		if @article.save
			authors.each do |author|
				authorship = Authorship.create!(:article_id => @article.id, :person_id => author.id)
			end
			redirect_to articles_url, :notice => "Article posted!"
		else
			@authors = Person.all.map {|person| ["#{person.name} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}", person.id]}
			render "new"
		end
	end
	
	def index
		@articles = Article.all
	end
	
end