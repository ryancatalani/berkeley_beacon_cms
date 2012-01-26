class PeopleController < ApplicationController
	before_filter :check_editor, :except => [:show]
	
	def index 
		@people = Person.all
	end
	
	def new
		@person = Person.new
	end
	
	def create
		p = params[:person]
		if p[:editor] == "0"
			x_arr = ('A'..'z').to_a + (0..9).to_a
			x_str = x_arr.sort_by{ rand }.first(25).join
			p[:password] = p[:password_confirmation] = x_str
		end
		@person = Person.new(p)		
		if @person.save
			redirect_to new_person_url, :notice => "Person created!"
		else
			render "new"
		end
	end
	
	def edit
		@person = Person.find(params[:id])
	end
	
	def update
		@person = Person.find(params[:id])
		if @person.update_attributes(params[:person])
			redirect_to people_path
		else
			render 'edit'
		end
	end
	
	def show
		if params[:id]
			@person = Person.find(params[:id])
		elsif params[:name]
			@person = Person.find_by_clean_full_name(params[:name])
		else
			redirect_to root_path and return
		end
		redirect_to root_path and return if @person.nil?
		@articles = @person.articles.order("created_at DESC")
	end
		
	
end
