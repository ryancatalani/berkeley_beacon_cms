class ArticlesController < ApplicationController
	before_filter :check_editor, :except => [:show]
	
	def new
		@article = Article.new
		@authors = Person.order("lastname ASC").all.map do |person|
			if person.other_designation.blank?
				["#{person.firstname} #{person.lastname} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}",
				person.id]
			else
				["#{person.firstname} #{person.lastname} #{person.other_designation == "*" ? "" : "/ #{person.other_designation}"}",
				person.id]
			end
		end
		@sections = Section.all.map { |s| [s.name, s.id] }
	end
	
	def create
		p = params[:article]
		if params[:mediafiles]
			cookies[:already_uploaded] ||= ''
			cookies[:already_uploaded] << params[:mediafiles].values.join(' ') << ' '
		end
		p[:articletype] = params[:articletype].to_i
		subs = params[:subtitle].nil? ? [] : params[:subtitle].values
		p[:subtitles] = subs
		p[:cleantitle] = p[:title].strip.downcase.gsub(/[^A-z0-9\s]/,'').split(' ').first(8).join('-')
		authors = []
		if params[:author].nil?
			authors << current_user
		else
			params[:author].values.each do |author_id|
				begin
					authors << Person.find(author_id.to_i)
				rescue
				end # begin
			end # each
		end # else
		@article = Section.find(params[:section]).articles.build(p)
				
		if @article.save
			@article.update_attribute(:views,0)
			authors.each do |author|
				authorship = Authorship.create!(:article_id => @article.id, :person_id => author.id)
			end
			if params[:mediafiles]
				params[:mediafiles].values.each do |m_id|
					Articlemediacontent.create!(:mediafile_id => m_id, :article_id => @article.id)
				end
				cookies[:already_uploaded] = []
			end
			redirect_to articles_url, :notice => "Article posted!"
		else
			@display_already_uploaded = true unless cookies[:already_uploaded].nil? or cookies[:already_uploaded].blank?
			logger.debug "cookies = #{cookies[:already_uploaded]} / already_uploaded = #{@already_uploaded}"
			@authors = Person.all.map {|person| ["#{person.firstname} #{person.lastname} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}", person.id]}
			@sections = Section.all.map { |s| [s.name, s.id] }
			render "new"
		end
	end
	
	def index
		@articles = Article.all
	end
	
	def edit
		# TODO: Doesn't update authors, etc
		@article = Article.find(params[:id])
		@sections = Section.all.map { |s| [s.name, s.id] }
		@authors = Person.order("lastname ASC").all.map do |person|
			if person.other_designation.blank?
				["#{person.firstname} #{person.lastname} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}",
				person.id]
			else
				["#{person.firstname} #{person.lastname} #{person.other_designation == "*" ? "" : "/ #{person.other_designation}"}",
				person.id]
			end
		end
	end
	
	def update
		# TODO: Doesn't update authors, etc
		@article = Article.find(params[:id])
		if @article.update_attributes(params[:article])
			redirect_to articles_path
		else
			@sections = Section.all.map { |s| [s.name, s.id] }
			@authors = Person.order("lastname ASC").all.map do |person|
				if person.other_designation.blank?
					["#{person.firstname} #{person.lastname} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}",
					person.id]
				else
					["#{person.firstname} #{person.lastname} #{person.other_designation == "*" ? "" : "/ #{person.other_designation}"}",
					person.id]
				end
			end
			render 'edit'
		end
	end
	
	def show
		logger.debug("article show params = #{params}")
		found = Article.where(:cleantitle => params[:title])
		if found.count == 1
			@article = found.first
			@title = @article.title
			@needs_og = true
			@og = {}
			@og[:title] = @article.title
			@og[:url] = @article.to_url
			@og[:image] = "http://berkeleybeacon.com/sample_image.jpg"
			@og[:description] = @article.excerpt.blank? ? false : @article.excerpt.blank?
			@article.update_attribute(:views, @article.views+1)
		else
			redirect_to root_path
		end
	end
	
end
