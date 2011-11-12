class SessionsController < ApplicationController
	def new
	end

	def create
		person = Person.find_by_email(params[:email])		
		if person && person.authenticate(params[:password])
			session[:user_id] = person.id
			redirect_to root_url, :notice => "Logged in!"
		else
			logger.debug "wrong credentials"
			flash.now.alert = "Invalid email or password"
			render "new"
		end
	end
	
	def destroy
		session[:user_id] = nil
		redirect_to root_url, :notice => "Logged out!"
	end

end
