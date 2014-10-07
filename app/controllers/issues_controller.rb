class IssuesController < ApplicationController
	before_filter :check_editor, :except => [:index, :show, :latest_issue_rss, :latest_issue_lead_image_rss, :latest_issue_second_image_rss]

	def index
		@issues = Issue.all.keep_if { |i| i.ok_to_display? }
		@include_bootstrap = true
	end

	def show
		@issue = Issue.find_by_release_date(params[:date])
		@include_bootstrap = true
	end

	def edit
		@issue = Issue.find(params[:id])
	end

	def update
		@issue = Issue.find(params[:id])
		p = params[:issue]
		thumbnail_created = false
		begin
			pdf_thumb = MiniMagick::Image.open(p[:pdf_url])
			pdf_thumb.format('jpg', 0)
			pdf_thumb.resize('400x400')

			connection = Fog::Storage.new({
				:provider => 'AWS',
				:aws_access_key_id => '***REMOVED***',
				:aws_secret_access_key=> '***REMOVED***'
			})
			directory = connection.directories.get("theberkeleybeacon")
			file = directory.files.create({
				:key => "#{@issue.release_date}-pdfthumb.jpg",
				:body => pdf_thumb.to_blob,
				:public => true
			})

			p[:pdf_thumb_url] = file.public_url
			thumbnail_created = true
		rescue
			logger.info "Issue creating PDF thumbnail"
		end

		if @issue.update_attributes(p) && thumbnail_created
			redirect_to articles_path
		else
			render 'edit'
		end
	end

	def latest_issue_rss
		articles_unsorted = Issue.latest.articles
		home = HomeLayout.last.articles
		@issue = Issue.latest
		
		@articles = []

		# @articles << articles_unsorted.where(section_id: Section.find_by_name('News').id)
		# @articles << articles_unsorted.where(section_id: Section.find_by_name('Feature').id)
		# @articles << articles_unsorted.where(section_id: Section.find_by_name('Opinion').id)
		# @articles << articles_unsorted.where(section_id: Section.find_by_name('Arts').id)
		# @articles << articles_unsorted.where(section_id: Section.find_by_name('Lifestyle').id)
		# @articles << articles_unsorted.where(section_id: Section.find_by_name('Sports').id)
		
		@articles << Article.find(home[:lead])
		@articles << home[:featured].map{|id| Article.find(id)}
		@articles << home[:middle].map{|id| Article.find(id)}

		@articles.flatten!
		render :layout => false
	end

	def latest_issue_lead_image_rss
		@issue = Issue.latest
		home = HomeLayout.last.articles
		@image = ''
		@image_article_link = ''
		lead_article = Article.find(home[:lead])

		if home[:lead_is_standalone_photo] == 'true' || home[:should_use_photo][:lead] == 'true'
			@image = lead_article.first_photo
			@image_article_link = lead_article.to_url
		elsif home[:should_use_photo][:featured][0] == 'true' && !Article.find(home[:featured][0]).first_photo.nil? && Article.find(home[:featured][0]).first_photo.horizontal?
			@image = Article.find(home[:featured][0]).first_photo
			@image_article_link = Article.find(home[:featured][0]).to_url
		elsif home[:should_use_photo][:featured][1] == 'true' && !Article.find(home[:featured][1]).first_photo.nil? && Article.find(home[:featured][1]).first_photo.horizontal?
			@image = Article.find(home[:featured][1]).first_photo
			@image_article_link = Article.find(home[:featured][1]).to_url
		else
			@image = Article.find(home[:featured][2]).first_photo
			@image_article_link = Article.find(home[:featured][2]).to_url
		end

		render 'latest_issue_image_rss'
	end

	def latest_issue_second_image_rss
		@issue = Issue.latest
		home = HomeLayout.last.articles
		@image = ''
		@image_article_link = ''
		i = 0

		middle_articles = home[:middle].map{|id| Article.find(id)}
		while @image.blank? && i < middle_articles.count
			img = middle_articles[i].first_photo
			if !img.nil? && home[:should_use_photo][:middle][i] && img.horizontal? 
				@image = img
				@image_article_link = middle_articles[i].to_url
			end
			i += 1
		end 

		render 'latest_issue_image_rss'
	end

end
