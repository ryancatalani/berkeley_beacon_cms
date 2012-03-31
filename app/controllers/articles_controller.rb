class ArticlesController < ApplicationController
	before_filter :check_editor, :except => [:show]
	# caches_action :show
	
	def new
		@article = Article.new
		@authors = Person.order("firstname ASC").all.map do |person|
			if person.other_designation.blank?
				["#{person.firstname} #{person.lastname} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}",
				person.id]
			else
				["#{person.firstname} #{person.lastname} #{person.other_designation == "*" ? "" : "/ #{person.other_designation}"}",
				person.id]
			end
		end
		@authors.unshift(["Choose an author",0])
		@sections = Section.all.map { |s| [s.name, s.id] }
		@series = [["None",0]] + Series.all.map {|s| [s.title, s.id] }
	end
	
	def create
		p = params[:article]
		if params[:mediafiles]
			cookies[:already_uploaded] ||= ''
			cookies[:already_uploaded] << params[:mediafiles].values.join(' ') << ' '
		end
		p[:articletype] = params[:articletype].to_i
		p[:series_id] = params[:series_id].to_i
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
			Twitter.update(@article.tweet) if Rails.env.production?
			redirect_to new_article_url, :notice => "Article posted!"
		else
			@display_already_uploaded = true unless cookies[:already_uploaded].nil? or cookies[:already_uploaded].blank?
			logger.debug "cookies = #{cookies[:already_uploaded]} / already_uploaded = #{@already_uploaded}"
			@authors = Person.all.map {|person| ["#{person.firstname} #{person.lastname} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}", person.id]}
			@sections = Section.all.map { |s| [s.name, s.id] }
			@series = [["None",0]] + Series.all.map {|s| [s.title, s.id] }
			render "new"
		end
	end
	
	def index
		@articles = Article.order("created_at DESC").first(30)
		@user_articles = current_user.articles.order("created_at DESC").first(6)
	end

	def search_edit
		index_name = Rails.env.production? ? "idx_production" : "idx"
		client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'] || 'http://:y1GqHmgP0jH2lL@dphiu.api.searchify.com')
		index = client.indexes(index_name)
		results = index.search(params[:q])
		@articles = results['results'].map{|r| r['docid']}.map{|id| Article.find(id.to_i)}.paginate(:page => params[:page], :per_page => 15)
		@q = params[:q]
	end
	
	def edit
		# TODO: Doesn't update authors, etc
		@article = Article.find(params[:id])
		@current_authors = @article.people
		@sections = Section.all.map { |s| [s.name, s.id] }
		@authors = Person.order("firstname ASC").all.map { |person| [person.official_name, person.id] }
		@authors.unshift(["Choose an author",0])
		@series = [["None",0]] + Series.all.map {|s| [s.title, s.id] }
	end
	
	def update
		# TODO: Doesn't update authors, etc
		if params[:mediafiles]
			cookies[:already_uploaded] ||= ''
			cookies[:already_uploaded] << params[:mediafiles].values.join(' ') << ' '
		end
		
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
		
		@article = Article.find(params[:id])
		p = params[:article]
		subs = params[:subtitle].nil? ? [] : params[:subtitle].values
		p[:subtitles] = subs
		# p[:cleantitle] = p[:title].strip.downcase.gsub(/[^A-z0-9\s]/,'').split(' ').first(8).join('-')
		p[:section_id] = params[:section].to_i
		p[:series_id] = params[:series_id].to_i
		if @article.update_attributes(p)
		  
		  Authorship.where(:article_id => @article.id).each { |a| a.delete }
		  
		  authors.each do |author|
				authorship = Authorship.create!(:article_id => @article.id, :person_id => author.id)
			end
			
			if params[:mediafiles]
				params[:mediafiles].values.each do |m_id|
					Articlemediacontent.create!(:mediafile_id => m_id, :article_id => @article.id)
				end
				cookies[:already_uploaded] = []
			end
			redirect_to articles_path
		else
			@sections = Section.all.map { |s| [s.name, s.id] }
			@authors = Person.order("lastname ASC").all.map { |person| [person.official_name, person.id] }
			@display_already_uploaded = true unless cookies[:already_uploaded].nil? or cookies[:already_uploaded].blank?
			@series = [["None",0]] + Series.all.map {|s| [s.title, s.id] }
			render 'edit'
		end
	end
	
	def show
		@include_responsive = true
		logger.debug("article show params = #{params}")
		found = Article.where(:cleantitle => params[:title])
		if found.count == 1
			@article = found.first
			@title = @article.title
			@needs_og = true
			@og = {}
			@og[:title] = @article.title
			@og[:url] = @article.to_url
			if @article.mediafiles.any?
				@og[:image] = @article.mediafiles.first.media.thumb_140.url.html_safe
			else
				@og[:image] = ''
			end
			@og[:description] = @article.excerpt.blank? ? false : @article.excerpt
			if @article.views.nil?
				@article.update_attribute(:views, 1)
			else
				@article.update_attribute(:views, @article.views+1)
			end
		else
		  begin
		    date = Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
	    rescue
	      redirect_to root_path and return
      end
		  a = Article.where(:created_at => (date.midnight)..(date + 1.day).midnight, :cleantitle => params[:title])
		  if a.count == 1
		    @article = a.first
  			@title = @article.title
  			@needs_og = true
  			@og = {}
  			@og[:title] = @article.title
  			@og[:url] = @article.to_url
        # @og[:image] = "http://berkeleybeacon.com/sample_image.jpg"
  			@og[:description] = @article.excerpt.blank? ? false : @article.excerpt.blank?
  			begin
  				@article.update_attribute(:views, @article.views+1)
  			rescue
  				@article.update_attribute(:views, 1)
  			end
			else
			  redirect_to root_path
		  end
		end
	end
	
end