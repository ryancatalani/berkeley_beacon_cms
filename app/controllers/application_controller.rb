class ApplicationController < ActionController::Base
	protect_from_forgery

	before_filter :intercept

	private

		def intercept
			unless current_user and current_user.editor?
				render 'pages/intercept', :layout => false and return
			end
		end

		def current_user
			@current_user ||= Person.find(session[:user_id]) if session[:user_id]
		end
		
		def check_editor
			redirect_to root_path unless current_user and current_user.editor?
		end
						
		def bylineify mediafile
			if mediafile.people.count == 0 and !mediafile.source.nil?
				return mediafile.source
			end
			people = mediafile.people
			return people.first.official_name if people.count == 1
			if people.count == 2
				ret = people.map {|p| p.official_name }.join(' and ')
			else
				last = people.pop
				ret = people.map {|p| p.official_name }.join(', ')
				ret << ', and ' << last.official_name
			end
			return ret
		end
		
		def bylineify_linked mediafile
			if mediafile.people.count == 0 and !mediafile.source.nil?
				return mediafile.source
			end
			people = mediafile.people
			return people.first.official_linked_name if people.count == 1
			if people.count == 2
				ret = people.map {|p| p.official_linked_name }.join(' and ')
			else
				last = people.pop
				ret = people.map {|p| p.official_linked_name }.join(', ')
				ret << ', and ' << last.official_linked_name
			end
			return ret
		end
		
		
		def bylineify_short people
			return people.first.full_name if people.count == 1
			if people.count == 2
				ret = people.map {|p| p.full_name }.join(' and ')
			else
				last = people.pop
				ret = people.map {|p| p.full_name }.join(', ')
				ret << ', ' << last.full_name
			end
			return ret
			
		end
		
		def popular_articles num=5
			Article.where(:created_at => (Time.now.midnight - 2.weeks)..(Time.now.midnight + 1.day)).order("views DESC").first(num)
		end
		
		def video_tag mediafile, height=500, width=820
			othertypes = Mediafile.where(:description => mediafile.description)
						
			ret = "<video width='#{width}' height='#{height}' controls='controls'>"

			othertypes.each do |v|
				type = v.media.url.split('.').last.first(3) == "ogv" ? "ogg" : "mp4"
				logger.debug "type = #{v.media.url.split('.').last.first(3)}"
				ret << "<source src='#{v.media.url}' type='video/#{type}' />"
			end

			ret << "Sorry, your browser can't view this video!"
			ret << "</video>"
			return ret
		end
		
		helper_method :current_user, :check_editor, :bylineify, :bylineify_linked, :bylineify_short, :popular_articles, :video_tag
	
end
