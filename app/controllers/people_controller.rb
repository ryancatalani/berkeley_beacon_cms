class PeopleController < ApplicationController
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
			redirect_to root_url, :notice => "Person created!"
		else
			render "new"
		end
	end
	
end
