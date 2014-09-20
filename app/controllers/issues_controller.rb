class IssuesController < ApplicationController
	before_filter :check_editor, :except => [:index, :show, :latest_issue_rss]

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

end
