class SectionsController < ApplicationController
	def show
		begin
			section = Section.find params[:id]
			@sname = section.name
			@articles = section.articles
		rescue
			redirect_to root_path
		end
	end

end
