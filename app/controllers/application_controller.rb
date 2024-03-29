class ApplicationController < ActionController::Base
	protect_from_forgery

	# before_filter :intercept
	# before_filter :acpsea
	# before_filter :check_individual_tracking_param

	def bylineify mediafile
		if mediafile.kind_of? Mediafile and mediafile.people.count == 0 and !mediafile.source.nil?
			return mediafile.source
		end
		people = mediafile.people.to_a
		return "Beacon Staff" if people.count == 0
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

	private

		def editor_logged_in
			current_user and current_user.editor?
		end

		def intercept
			unless current_user and current_user.editor?
				render 'pages/intercept', :layout => false and return
			end
		end

		# def acpsea
		# 	g = Geocoder.search(request.ip).first
		# 	# g = Geocoder.search("70.102.96.7").first
		# 	begin
		# 		l1 = [g.data["latitude"].to_d, g.data["longitude"].to_d]
		# 		# l2 = ["47.605".to_d, "-122.33".to_d]
		# 		l2 = ["42.33".to_d, "71.02".to_d]
		# 		if Geocoder::Calculations.distance_between(l1, l2) > 150
		# 			@acpsea = true
		# 		end
		# 	rescue
		# 		@acpsea = true
		# 	end
		# end

		def current_user
			@current_user ||= Person.find(session[:user_id]) if session[:user_id]
		end

		def check_editor
			redirect_to root_path unless current_user and current_user.editor?
		end

		

		def bylineify_linked mediafile
			if mediafile.kind_of? Mediafile and !mediafile.source.blank?
				return mediafile.source
			end
			people = mediafile.people.to_a.sort_by{|p| p.lastname}
			return "Beacon Staff" if people.count == 0
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
			return "Beacon Staff" if people.count == 0
			return people.first.full_name if people.count == 1

			if people.count == 2
				ret = people.to_a.map {|p| p.full_name }.join(' and ')
			else
				last = people.to_a.pop
				ret = people.to_a.map {|p| p.full_name }.join(', ')
				ret << ', ' << last.full_name
			end
			return ret

		end

		def popular_articles num=5
			return PopularSnapshot.latest_most_viewed
			# num_days = 2
			# ret = Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).where(:draft => [false, nil]).order("views DESC").first(num)
			# while ret.count < num
			# 	num_days += 1
			# 	ret << Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).where(:draft => [false, nil]).order("views DESC").first(num)
			# 	ret.flatten!
			# 	ret.uniq!
			# end
			# return ret.first(num).sort_by{|a| a.views}.reverse
		end

		def popular_articles_shared
			PopularSnapshot.latest_most_shared
		end

		def video_tag mediafile, height=500, width=820
			othertypes = Mediafile.where(:title => mediafile.title)
			return nil if othertypes.nil?

			ret = "<video width='#{width}' height='#{height}' controls='controls'>"

			othertypes.each do |v|
				type = v.media.url.split('.').last.first(3) == "ogv" ? "ogg" : "mp4" rescue next
				ret << "<source src='#{v.media.url}' type='video/#{type}' />"
			end

			ret << "Sorry, your browser can't view this video!"
			ret << "</video>"
			return ret
		end

		def og_title
			return @og[:title] if !@og.nil? and !@og[:title].nil?
			return @title if !@title.nil?
			return "The Berkeley Beacon"
		end

		def bb_video_tag mediafile
			render 'shared/video_tag', :video => mediafile
		end

		def latest_ed_cartoon
			if EditorialCartoon.count > 0
				return EditorialCartoon.latest
			else
				s = Series.find_by_title("Editorial Cartoons")
				if s
					return s.mediafiles.order("created_at DESC").first
				else
					return nil
				end
			end
		end

		def current_twitter
			beacon = {
						:consumer_key => ENV['TWITTER_CONSUMER_KEY'],
						:consumer_secret => ENV['TWITTER_CONSUMER_SECRET'],
						:oauth_token => ENV['TWITTER_OAUTH_TOKEN'],
						:oauth_token_secret => ENV['TWITTER_OAUTH_SECRET']
					}
			test = {
				:consumer_key => ENV['TWITTER_TEST_CONSUMER_KEY'],
				:consumer_secret => ENV['TWITTER_TEST_CONSUMER_SECRET'],
				:oauth_token => ENV['TWITTER_TEST_OAUTH_TOKEN'],
				:oauth_token_secret => ENV['TWITTER_TEST_OAUTH_SECRET']
			}
			if Rails.env.production?
				return Twitter::Client.new(beacon)
			else
				return Twitter::Client.new(test)
			end
		end

		def home_layout_or_article_last_updated
			begin
				return Digest::MD5.hexdigest "#{HomeLayout.maximum(:updated_at).to_i}-#{Article.maximum(:updated_at).to_i}-#{Article.count}"
			rescue
				return Digest::MD5.hexdigest "#{Tagging.maximum(:updated_at).to_i}-#{Article.maximum(:updated_at).to_i}-#{Article.count}"
			end
		end

		def individual_tracking_param
			['eid', current_user.id]
		end

		def check_individual_tracking_param
			url = request.original_url
			if editor_logged_in && !url.include?(individual_tracking_param.join('='))
				uri = URI.parse(url)
				params = URI.decode_www_form(uri.query || '') << individual_tracking_param
				uri.query = URI.encode_www_form(params)
				redirect_to uri.to_s
			end
		end

		def api_wrangle_articles(articles)
			ret = []
			articles.each do |a|
				a_ret = {
					id: a.id,
					url: a.to_url,
					title: a.extra_title,
					date: a.created_at.year == Time.zone.now.year ? a.created_at.strftime('%b. %d') : a.created_at.strftime('%b. %d, %Y')
				}
				if a.first_photo
					a_ret[:thumb_40] = a.first_photo.media.thumb_40.url
					a_ret[:thumb_220] = a.first_photo.media.thumb_220.url
				end
				ret << a_ret
			end
			return ret
		end



		helper_method :current_user, :check_editor,
			:bylineify, :bylineify_linked, :bylineify_short,
			:popular_articles, :popular_articles_shared,
			:video_tag, :og_title, :editor_logged_in, :bb_video_tag,
			:latest_ed_cartoon, :current_twitter, :home_layout_or_article_last_updated, :individual_tracking_param,
			:api_wrangle_articles


end
