include ActionView::Helpers::AssetTagHelper
# include ActionView::Helpers::ApplicationHelper

class ArticlesController < ApplicationController
	before_filter :check_editor, :except => [:show, :increase_pageview, :pop_data_api]

	def newnew
		@title = "Articulator"
		@no_bootstrap = true
		@body_class = "articulator"

		@article = Article.new

		@authors = Person.order("firstname ASC").all.map do |person|
		if person.other_designation.blank?
			["#{person.firstname} #{person.lastname} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}",
				person.id]
		else
			["#{person.firstname} #{person.lastname} #{person.other_designation == "*" ? "" : "/ #{person.other_designation}"}",
				person.id]
			end
		end
		@authors.unshift(["Choose an author",0])

		@sections = Section.all.map { |s| [s.name, s.id] }
		@issues = Issue.all.sort_by{|i| i.release_date }.reverse.map {|i| [i.release_date_f, i.id]}.insert(1,["None/Online only", 0])
		@blogs = [["None", 0]] + Blog.all.map {|b| [b.title, b.id] }

		@topics = Topic.all.map{|t| [t.title, t.id]}
		@series = [["None",0]] + Series.all.map {|s| [s.title, s.id] }

		render 'newnew', layout: 'bare'
	end

	def new
		@article = Article.new
		@authors = Person.order("firstname ASC").all.map do |person|
		if person.other_designation.blank?
			["#{person.firstname} #{person.lastname} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}",
				person.id]
		else
			["#{person.firstname} #{person.lastname} #{person.other_designation == "*" ? "" : "/ #{person.other_designation}"}",
				person.id]
			end
		end
		@authors.unshift(["Choose an author",0])
		@sections = Section.all.map { |s| [s.name, s.id] }
		@series = [["None",0]] + Series.all.map {|s| [s.title, s.id] }
		@blogs = [["None", 0]] + Blog.all.map {|b| [b.title, b.id] }
		@issues = Issue.all.sort_by{|i| i.release_date }.reverse.map {|i| [i.release_date_f, i.id]}.insert(1,["None/Online only", 0])
		@topics = Topic.all.map{|t| [t.title, t.id]}
		@current_topics = @article.topics.map{|t| t.id} || []
		@can_queue_tweet = can_queue_tweet?
	end

	def create
		is_draft = params[:commit].include?("draft")
		p = params[:article]
		if params[:mediafiles]
			cookies[:already_uploaded] ||= ''
			cookies[:already_uploaded] << params[:mediafiles].values.join(' ') << ' '
		end
		p[:articletype] = params[:articletype].to_i
		p[:series_id] = params[:series_id].to_i
		subs = params[:subtitle].nil? ? [] : params[:subtitle].values.map{|s| Rumoji.encode(s)}
		p[:subtitles] = subs
		p[:title] = Rumoji.encode(p[:title])
		cleantitle = p[:title].strip.downcase.gsub(/[^A-z0-9\s]/,'').split(' ').first(8).join('-')
		if !Article.find_by_cleantitle(cleantitle).nil?
			cleantitle = cleantitle + '-' + (Article.last.id+1).to_s.last(2)
		end
		p[:cleantitle] = cleantitle
		authors = []
		if params[:author].nil?
			authors << current_user
		else
			params[:author].map(&:to_i).each do |author_id|
				begin
					authors << Person.find(author_id.to_i)
				rescue
				end # begin
			end # each
		end # else

		if is_draft
			p[:body] = "[Fill in]" if p[:body].blank?
			p[:excerpt] = " " if p[:excerpt].blank?
		end
		p[:body] = p[:excerpt] if p[:link_only] == "1"

		if p[:blog_id].to_i.zero? or p[:blog_id].nil?
			@article = Section.find(p[:section_id]).articles.build(p)
		else
			p[:section_id] = nil
			@article = Blog.find(p[:blog_id]).articles.build(p)
		end

		queue_tweet = !params[:post_when].nil? and params[:post_when] == "post_later"

		p[:body] = Rumoji.encode(p[:body])
		p[:excerpt] = Rumoji.encode(p[:excerpt])

		if @article.save
			@article.update_attribute(:views,0)
			@article.update_attribute(:draft,is_draft)
			authors.each do |author|
				authorship = Authorship.create!(:article_id => @article.id, :person_id => author.id)
			end
			if params[:mediafiles]
				params[:mediafiles].values.each do |m_id|
					Articlemediacontent.create!(:mediafile_id => m_id, :article_id => @article.id)
				end
				cookies[:already_uploaded] = []
			end
			if params[:topic]
				t = params[:topic].map(&:to_i).each do |t_id|
					Topical.create!(:article_id => @article.id, :topic_id => t_id)
				end
			end
			if !params[:beacon_event_url].blank?
				begin
					events_url_regex = /events\/(.+)\//
					uid = events_url_regex.match(params[:beacon_event_url])[1]
					logger.debug "uid = #{uid}"
					event = Event.find_by_uid(uid)
					logger.debug "event = #{event.inspect}"
					ArticleEventBinder.create!(:article_id => @article.id, :event_id => event.id)
				rescue
				end
			end
			# tweet(is_draft, queue_tweet)
			redirect_to new_article_url, :notice => "Article #{is_draft ? 'saved!' : 'posted'}!"
		else
			logger.debug @article.errors.full_messages.join("\n")
			@display_already_uploaded = true unless cookies[:already_uploaded].nil? or cookies[:already_uploaded].blank?
			@authors = Person.all.map {|person| ["#{person.firstname} #{person.lastname} / Beacon #{(person.staff? or person.editor?) ? "Staff" : "Correspondent"}", person.id]}
			@sections = Section.all.map { |s| [s.name, s.id] }
			@series = [["None",0]] + Series.all.map {|s| [s.title, s.id] }
			@blogs = [["None", 0]] + Blog.all.map {|b| [b.title, b.id] }
			@issues = Issue.all.map {|i| [i.release_date_f, i.id]}.reverse.insert(1,["None/Online only", 0])
			render "new"
		end
	end

	def index
		@title = "Dashboard"
		@articles = Article.order("created_at DESC").first(30)
		@user_articles = current_user.articles.order("created_at DESC").first(6)
		
		@latest_issues = Issue.latest(4)
		@section_total = {}
		%w(news opinion arts lifestyle sports feature events beyond).each do |s|
			begin
				@section_total[s] = @latest_issues.map{|i| i.social_quotient_by_section(s)}.sum.round(1).to_s
			rescue
				@section_total[s] = 0
			end
		end
	end

	def pop_views_ck_data
		snapshot_count = 24 * 7
		latest_pop = PopularSnapshot.last(snapshot_count)

		hours = []
		snapshot_count.times do |x|
			hours << snapshot_count.hours.ago - x.hours
		end

		# latest_* = [ [hour], [hour], etc ]
		# hour = [ [first most popular], [second most popular], etc ]

		pop_views = latest_pop.map &:most_viewed
		pop_shares = latest_pop.map &:most_shared

		@pop_views_final = {}
		@pop_shares_final = {}

		@pop_views_ck = {}

		pop_views.flatten(1).map(&:first).uniq.each do |artcl|
			@pop_views_final[artcl] = Array.new(snapshot_count, 0)
		end

		pop_shares.flatten(1).map(&:first).uniq.each do |artcl|
			@pop_shares_final[artcl] = Array.new(snapshot_count, 0)
		end

		pop_views.each_with_index do |snapshot, i|
			snapshot.each do |inner|
				article_id = inner.first
				count = inner.last
				@pop_views_final[article_id][i] = count
			end
		end

		pop_shares.each_with_index do |snapshot, i|
			snapshot.each do |inner|
				article_id = inner.first
				count = inner.last
				@pop_shares_final[article_id][i] = count
			end
		end

		@pop_views_ck = @pop_views_final.map do |k,v|
			name = Article.find(k).title rescue "Article #{k}"
			hours_data = {}
			hours.reverse.each_with_index do |h,i|
				hours_data[h] = v[i]
			end
			{ :name => name, :data => hours_data }
		end

		@pop_views_final_keys = @pop_views_final.map{|k,v| Article.find(k).title rescue "Article #{k}" }.to_s
		@pop_shares_final_keys = @pop_shares_final.map{|k,v| Article.find(k).title rescue "Article #{k}" }.to_s

		@pop_views_final = @pop_views_final.map{|k,v| v}
		@pop_shares_final = @pop_shares_final.map{|k,v| v}


		# Returns:
		# [
		#	[views, views, views, ...],
		#	[views, views, views, ...],
		#	etc
		# ]

		pop_views_for_axes = pop_views.flatten(1).map(&:last)
		@pop_views_max = pop_views_for_axes.max
		@pop_views_min = pop_views_for_axes.min

		pop_shares_for_axes = pop_shares.flatten(1).map(&:last)
		@pop_shares_max = pop_shares_for_axes.max
		@pop_shares_min = pop_shares_for_axes.min

		@times = []
		snapshot_count.times{|n| @times << n+1 }

		render :json => @pop_views_ck
	end

	def search_edit
		article_response = Article.search(params[:q]).page(params[:page])
		@articles = article_response.records
		@q = params[:q]
	end

	def search_edit_frontend
		@title = "Search"
	end

	def search_edit_frontend_data
		article = Article.find(params[:article_id])

		if article.nil?
			render json: {} and return
		end

		ret = {}

		if article.mediafiles.any?
			mediafiles = article.mediafiles.map {|m| {id: m.id, title: m.title}  }
			ret[:mediafiles] = mediafiles
		end

		ret[:pageview_count] = article.pageview_count
		ret[:unique_pageview_count] = article.unique_pageview_count
		ret[:total_social_shares] = article.total_social_shares

		render json: ret
	end

	def edit
		@article = Article.find(params[:id])
		@current_authors = @article.people.map{|p| p.id}
		@sections = Section.all.map { |s| [s.name, s.id] }
		@authors = Person.order("firstname ASC").all.map { |person| [person.official_name, person.id] }
		@authors.unshift(["Choose an author",0])
		@series = [["None",0]] + Series.all.map {|s| [s.title, s.id] }
		@issues = Issue.all.sort_by{|i| i.release_date }.reverse.map {|i| [i.release_date_f, i.id]}.insert(1,["None/Online only", 0])
		@topics = Topic.all.map{|t| [t.title, t.id]}
		@current_topics = @article.topics.map{|t| t.id} || []
		@can_queue_tweet = can_queue_tweet?
		@event_url = @article.events.count > 0 ? @article.events.last.url(true) : nil
	end

	def update
		is_draft = params[:commit].include?("draft")
		if params[:mediafiles]
			cookies[:already_uploaded] ||= ''
			cookies[:already_uploaded] << params[:mediafiles].values.join(' ') << ' '
		end

		authors = []
		if params[:author].nil?
			authors << current_user
		else
			params[:author].map(&:to_i).each do |author_id|
				begin
					authors << Person.find(author_id.to_i)
				rescue
				end # begin
			end # each
		end # else

		@article = Article.find(params[:id])
		was_draft = @article.draft?
		p = params[:article]
		subs = params[:subtitle].nil? ? [] : params[:subtitle].values.map{|s| Rumoji.encode(s)}
		p[:subtitles] = subs
		p[:title] = Rumoji.encode(p[:title])
		# p[:cleantitle] = p[:title].strip.downcase.gsub(/[^A-z0-9\s]/,'').split(' ').first(8).join('-')
		p[:section_id] = params[:section].to_i
		p[:series_id] = params[:series_id].to_i
		if is_draft
			p[:body] = "[Fill in]" if p[:body].blank?
			p[:excerpt] = " " if p[:excerpt].blank?
		end
		p[:body] = p[:excerpt] if p[:link_only] == "1"
		if was_draft
			cleantitle = p[:title].strip.downcase.gsub(/[^A-z0-9\s]/,'').split(' ').first(8).join('-')
			if !Article.find_by_cleantitle(cleantitle).nil?
				cleantitle = cleantitle + '-' + (Article.last.id+1).to_s.last(2)
			end
			p[:cleantitle] = cleantitle
		end

		queue_tweet = !params[:post_when].nil? and params[:post_when] == "post_later"

		p[:body] = Rumoji.encode(p[:body])
		p[:excerpt] = Rumoji.encode(p[:excerpt])

		if @article.update_attributes(p)
			@article.update_attribute(:draft,is_draft)
			Authorship.where(:article_id => @article.id).each { |a| a.delete }

			authors.each do |author|
				authorship = Authorship.create!(:article_id => @article.id, :person_id => author.id)
			end

			if params[:mediafiles]
				params[:mediafiles].values.each do |m_id|
					Articlemediacontent.create!(:mediafile_id => m_id, :article_id => @article.id)
				end
				cookies[:already_uploaded] = []
			end

			Topical.where(:article_id => @article.id).destroy_all
			if params[:topic]
				t = params[:topic].map(&:to_i).each do |t_id|
					Topical.create!(:article_id => @article.id, :topic_id => t_id)
				end
			end
			if !params[:beacon_event_url].blank?
				# begin
					events_url_regex = /events\/(.+)\//
					uid = events_url_regex.match(params[:beacon_event_url])[1]
					event = Event.find_by_uid(uid)
					aeb = ArticleEventBinder.where(:article_id => @article.id)
					if aeb.count > 0
						aeb.first.update_attribute(:event_id, event.id)
					else
						ArticleEventBinder.create!(:article_id => @article.id, :event_id => event.id)
					end
				# rescue
				# end
			end
			# tweet(is_draft, queue_tweet) if was_draft
			redirect_to "/articles#a_#{@article.id}"
		else
			@sections = Section.all.map { |s| [s.name, s.id] }
			@authors = Person.order("lastname ASC").all.map { |person| [person.official_name, person.id] }
			@display_already_uploaded = true unless cookies[:already_uploaded].nil? or cookies[:already_uploaded].blank?
			@series = [["None",0]] + Series.all.map {|s| [s.title, s.id] }
			@issues = Issue.all.map {|i| [i.release_date_f, i.id]}.reverse.insert(1,["None/Online only", 0])
			render 'edit'
		end
	end

	def show
		@article = Article.where(:cleantitle => params[:title]).order('created_at DESC').first

		raise ActionController::RoutingError.new('Not Found') if @article.nil?
		redirect_to root_path and return if @article.draft? && !editor_logged_in

		@include_responsive = true
		@include_bootstrap_carousel = true
		@title = @article.title
		@article_mediafiles = @article.visual_mediafiles
		@article_img_class = ""
		if @article_mediafiles.count == 1 and @article.videos.empty?
			if @article_mediafiles.first.horizontal?
				@article_img_class = "single_image_body"
			else
				@article_img_class = "single_image_body vertical_single_image_body"
			end
		end

		@needs_og = true
		@og = {}
		@og[:title] = @article.title
		@og[:url] = @article.to_url(:full => true)
		if @article.visual_mediafiles.any?
			@og[:image] = @article.visual_mediafiles.first.media.url.html_safe rescue nil
			@twitter_img = @article.visual_mediafiles.first.media.thumb_460.url.html_safe rescue nil
		else
			@og[:image] = nil
		end
		@og[:description] = @article.excerpt.blank? ? nil : @article.excerpt
		if @article.people.count == 1 && !@article.people.first.twitter.blank?
			@twitter_creator = "@#{@article.people.first.twitter}"
		else
			@twitter_creator = "@beaconupdate"
		end


		# if params[:a14]=="true" && editor_logged_in
		if (cookies[:a14_hide_always].nil? && params[:proto] != "false" && !@article.videos.any?) || (params[:amp] && params[:amp] == "true")
			@body_class = "a14_article"
			# @show_prototype_banner = cookies[:a14_hide_banner] != "true"
			# @article_section = @article.section.nil? ? Section.find_by_name('News') : @article.section
			@article_section = Section.find_by_name('News')
			@article_section_name = @article_section.name
			@article_section_slug = @article_section.clean_url
			if !@article.blog.nil?
				@article_section = 'Blog'
				@article_section_name = 'Blog'
				@article_from_blog = true
				@article_section_slug = 'blogs'
			elsif !@article.section.nil?
				@article_section = @article.section
				@article_section_name = @article_section.name
				@article_section_slug = @article_section.clean_url
			end
					

			@section_issue_articles = Article.where(:issue_id => Issue.latest.id, :section_id => @article_section.id, :draft => false).all.delete_if {|a| a.id == @article.id } rescue []

			if @article.people.any? && @article.people.first.full_name == "Editorial Board"
				@ed_board_explainer = true
			end

			if @article.title.downcase.include? "letter to the editor"
				@letter_editor_explainer = true
			end

			@should_show_sidebar = !@article.series.nil? || !@article.topics.blank? || @section_issue_articles.count > 0 || @ed_board_explainer || @letter_editor_explainer

			@other_sections = %w(News Opinion Arts Lifestyle Sports Feature Multimedia Events Beyond).delete_if {|n| n == @article_section.name rescue false}.map{|s| Section.find_by_name s}.compact

			@canonical_url = @article.to_url(full: true)

			if params[:amp] && params[:amp] == "true"
				render('show2014amp', layout: false) && return
			else 
				render('show2014', :layout => 'article2014') && return
			end
		end

		if @article.section and @article.section.name == "Feature"
			render('show2013', :layout => 'article2013') && return
		end


	end

	def destroy
		article = Article.find(params[:id])
		article.social_posts.destroy_all
		article.destroy
		redirect_to articles_path
	end

	def increase_pageview
		article_id = params[:article_id].to_i
		encoded_ip_address = Digest::SHA1.hexdigest(request.remote_ip).to_s
		Pageview.create!(:obj_pageviews_id => article_id, :encoded_ip_address => encoded_ip_address, :obj_pageviews_type => "Article")
		render :text => "Done."
	end

	def check_slug
		slug = params[:slug]
		if Article.find_by_cleantitle(slug).nil?
			render text: 'false'
		else
			render text: 'true'
		end
	end

	def pop_data_api
		payload = {
			viewed: PopularSnapshot.latest_most_viewed_api,
			shared: PopularSnapshot.latest_most_shared_api
		}
		render json: payload
	end

	private

	def expire_article_touches
		expire_page :controller => 'sections', :action => 'show'
	end

	def can_queue_tweet?
		# Return true only if it's a Wednesday or Thursday, or in development
		Time.now.strftime("%A").in?( %w(Wednesday Thursday) ) || Rails.env.development?
	end

	def tweet(is_draft, queue_tweet, was_draft=false)
		if !is_draft
			if queue_tweet
				@article.social_posts.create!(:status_text => @article.tweet, :network => 1, :in_queue => true, :posted => false)
				logger.debug('Queued tweet')
			else
				current_twitter.update(@article.tweet) rescue return ''
			end
		end
	end

end