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
		@mediafile = Mediafile.new(p)
		if @mediafile.save
			if params[:sourcetype] == "in"
				creators.each do |creator|
					attribution = Attribution.create!(:mediafile_id => @mediafile.id, :person_id => creator.id)
				end
			end
			@mediafile.update_attribute(:created_at, date) if date
			@mediafile.update_attribute(:updated_at, date) if date
			@mediafile.check_dimensions
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
		if @mediafile.update_attributes(params[:mediafile])
			if params[:sourcetype] == "in"
				@mediafile.attributions.each{|a| a.destroy}
				creators.each do |creator|
					attribution = Attribution.create!(:mediafile_id => @mediafile.id, :person_id => creator.id)
				end
			end
			@mediafile.check_dimensions
			redirect_to articles_path
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
