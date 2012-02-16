class MediafilesController < ApplicationController
	
	respond_to :html, :js

	def index
	end

	def new
		@mediafile = Mediafile.new
		@authors = Person.order("lastname ASC").all.map {|person| ["#{person.firstname} #{person.lastname} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}", person.id]}
	end
	
	def create
		p = params[:mediafile]
		p[:mediatype] = params[:mediatype].to_i
		p[:source] = params[:source]
		@mediafile = Mediafile.new(p)
		if @mediafile.save
			Attribution.create!(:mediafile_id => @mediafile.id, :person_id => params[:creator].to_i) if params[:sourcetype] == "in"
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
	  @authors = Person.order("lastname ASC").all.map { |person| [person.official_name, person.id] }
  end
  
  def update
		@mediafile = Mediafile.find(params[:id])
		if @mediafile.update_attributes(params[:mediafile])
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
