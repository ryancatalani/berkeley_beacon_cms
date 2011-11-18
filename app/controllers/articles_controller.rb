class ArticlesController < ApplicationController
	before_filter :check_editor
	
	def new
		@article = Article.new
		@authors = Person.all.map {|person| ["#{person.firstname} #{person.lastname} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}", person.id]}
		@sections = Section.all.map { |s| [s.name, s.id] }
	end
	
	def create
		p = params[:article]
		p[:articletype] = params[:articletype].to_i
		subs = params[:subtitle].nil? ? [] : params[:subtitle].values
		p[:subtitles] = subs
		p[:cleantitle] = p[:title].strip.downcase.gsub(/[^A-z0-9\s]/,'').split(' ').first(8).join('-')
		authors = []
		if params[:author].nil?
			authors << current_user
		else
			params[:author].each do |author|
				begin
					authors << Person.find(author)
				rescue
				end # begin
			end # each
		end # else
		logger.debug("authors = #{authors}")
		@article = Section.find(params[:section]).articles.build(p)
		
		if @article.save
			authors.each do |author|
				authorship = Authorship.create!(:article_id => @article.id, :person_id => author.id)
			end
			redirect_to articles_url, :notice => "Article posted!"
		else
			@authors = Person.all.map {|person| ["#{person.firstname} #{person.lastname} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}", person.id]}
			@sections = Section.all.map { |s| [s.name, s.id] }
			render "new"
		end
	end
	
	def index
		@articles = Article.all
	end
	
	def show
		logger.debug("article show params = #{params}")
		found = Article.where(:cleantitle => params[:title])
		if found.count == 1
			@article = found.first
		else
			redirect_to root_path
		end
	end
	
end
