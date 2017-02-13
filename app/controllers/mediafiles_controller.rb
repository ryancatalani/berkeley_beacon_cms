class MediafilesController < ApplicationController

	respond_to :html, :js

	def index
	end

	def new
	  @mediafile = Mediafile.new
	  @authors = Person.order("firstname ASC").all.map { |person| [person.official_name, person.id] }
	  @authors_type = '[' + Person.order("lastname ASC").all.map { |person| "'#{person.official_name}'" }.join(',') + ']'
	  @authors_count = Person.count
	end

	def create
		p = params[:mediafile]
		p[:mediatype] = params[:mediatype].to_i
		creators = []
		if params[:creator].nil?
			creators << current_user
		else
			params[:creator].values.each do |author_id|
				begin
					creators << Person.find(author_id.to_i)
				rescue
				end # begin
			end # each
		end # else
		date = nil
		if params[:cartoon_date]
			d = params[:cartoon_date]
			date = Time.new(d[:year], d[:month], d[:day])
			logger.debug ("different date: #{date}")
		end

		if p[:is_editorial_cartoon] && (p[:is_editorial_cartoon] == true || p[:is_editorial_cartoon] == "true")

			issue_id = params[:issue][:id]
			issue_date = Issue.find(issue_id).release_date
			slug = issue_date.strftime("%Y-%m-%d") + "-#{Time.now.min}#{Time.now.sec}"
			cartoon = EditorialCartoon.create!(
				issue_date: issue_date,
				issue_id: issue_id,
				slug: slug
			)
			p[:editorial_cartoon_id] = cartoon.id
		end

		@mediafile = Mediafile.new(p)
		if @mediafile.save
			if params[:sourcetype] == "in"
				creators.each do |creator|
					attribution = Attribution.create!(:mediafile_id => @mediafile.id, :person_id => creator.id)
				end
			end
			@mediafile.update_attribute(:created_at, date) if date
			@mediafile.update_attribute(:updated_at, date) if date
			@mediafile.check_dimensions unless @mediafile.mediatype == 5

			respond_with @mediafile #, :location => mediafiles_url
			# # format.html { redirect_to mediafiles_path }
			# format.js
		else
			# respond_with
			# format.html { render :action => 'new' }
			# format.js
		end
	end

	def edit
	  @mediafile = Mediafile.find(params[:id])
	  @authors = Person.order("firstname ASC").all.map { |person| [person.official_name, person.id] }
  end

  def update
		@mediafile = Mediafile.find(params[:id])
		creators = []
		if params[:creator].nil?
			creators << current_user
		else
			params[:creator].values.each do |author_id|
				begin
					creators << Person.find(author_id.to_i)
				rescue
				end # begin
			end # each
		end # else

		if !@mediafile.editorial_cartoon_id.nil?
			cartoon = @mediafile.editorial_cartoon
			issue_id = params[:issue][:id]
			issue_date = Issue.find(issue_id).release_date
			cartoon.update_attributes(issue_id: issue_id, issue_date: issue_date)
		end

		if @mediafile.update_attributes(params[:mediafile])
			if params[:sourcetype] == "in"
				@mediafile.attributions.each{|a| a.destroy}
				creators.each do |creator|
					attribution = Attribution.create!(:mediafile_id => @mediafile.id, :person_id => creator.id)
				end
			end
			@mediafile.check_dimensions

			if !@mediafile.editorial_cartoon_id.nil?
				redirect_to admin_editorial_cartoons_path and return
			else
				redirect_to articles_path
			end
			
		else
			render 'edit'
		end
  end

  def destroy
    file = Mediafile.find(params[:id])
    file.destroy
    redirect_to articles_path
  end


end
