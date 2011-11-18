class SectionsController < ApplicationController
	def show
		begin
			section = Section.find_by_name params[:name]
			@sname = section.name
			@articles = section.articles
		rescue
			redirect_to root_path
		end
	end

end
