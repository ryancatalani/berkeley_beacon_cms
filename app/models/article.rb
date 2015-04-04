class Article < ActiveRecord::Base
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	validates_presence_of :title, :body, :articletype
	attr_accessible :title, :body, :excerpt, :articletype, :people, :subtitles, :cleantitle, :series_id, :section_id, :archive, :archive_images, :blog_id, :link_only, :link, :issue_id, :event_day
	has_many :authorships
	has_many :people, :through => :authorships
	has_many :taggings
	has_many :tags, :through => :taggings
	has_many :topicals
	has_many :topics, :through => :topicals
	has_many :articlemediacontents
	has_many :mediafiles, :through => :articlemediacontents
	has_many :social_posts
	has_many :pageviews, :as => :obj_pageviews
	has_many :article_event_binders
	has_many :events, :through => :article_event_binders
	belongs_to :section
	belongs_to :series
	belongs_to :blog
	belongs_to :issue
	serialize :archive_images
	serialize :subtitles
	serialize :social_shares
	before_save :check_clean_title
	after_update :update_queued_tweets
	after_destroy :remove_associated_tweets
	scope :published, -> { where(draft: false) }

	def to_url(opts={})
		if link_only
			return link
		else
			c = created_at
			base = blog.nil? ? section.clean_url : blog.cleantitle rescue 'web'
			path = "/#{base}/#{c.year}/#{c.month}/#{c.day}/#{cleantitle}"
			return "http://www.berkeleybeacon.com"+path if opts[:full] and opts[:full] = true
			return path
		end
	end

	def to_url_with_tracking(source="twt",medium="social",campaign="sp_th")
		"#{to_url(:full=>true)}?utm_source=#{source}&utm_medium=#{medium}&utm_campaign=#{campaign}"
	end

	def tweet
		tco_length = 23
		tweet_max = 140

		ret = "#{title} #{to_url_with_tracking}"
		length = tco_length + 1 + title.length # Length of a t.co link + " " + title

		if twitter_people && (length + twitter_people.length < tweet_max)
			ret << twitter_people
			length += twitter_people.length
		end

		return ret
	end

	def show_share_tweet
		tweet = title + " " + to_url(:full=>true) + " via @BeaconUpdate"
		return CGI.escape(tweet)
	end

	def first_photo
		if images.count > 0 and !images.first.media.nil?
			return images.first
		elsif visual_mediafiles.count > 0
			return visual_mediafiles.first
		end
		return nil
	end

	def extra_title
		if section.name == "Opinion" && !title.downcase.include?("letter to")
			if people.any? && !people.first.nil? && people.first.full_name == "Editorial Board"
				return "Editorial: #{title}"
			else
				return "Op-Ed: #{title}"
			end
		end

		return title
	end

	def thumb
		return nil unless first_photo
		first_photo.media.thumb_140.url
	end

	def images
		mediafiles.where('mediatype <> 2 AND mediatype <> 5').order(:id)
	end

	def videos
		mediafiles.where(:mediatype => 2)
	end

	def audio_files
		mediafiles.where(:mediatype => 5)
	end

	def visual_mediafiles
		mediafiles.where('mediatype <> 5').order(:id)
	end

	def first_video_poster
		videos.first.media
	end

	def nice_created_at(opts={})
		if opts[:short]
			return (created_at - 5.hours).strftime("%B %e, %Y")
		else
			return (created_at - 5.hours).strftime("%B %e, %Y at %l:%M %P")
		end
	end

	def twitter_names
		if people.any? && people.map{ |p| !p.twitter.blank? }.all?
			t = []
			ret = ''
			people.each do |p|
				t << "@#{p.twitter}" unless p.twitter.blank?
			end
			if t.count == 1
				ret = t.first
			elsif t.count == 2
				ret = t.join(' & ')
			else
				last = t.pop
				ret = t.join(' ')
				ret << " & #{last}"
			end
			return ret
		end
		return ''
	end

	def indexable_info
		a = {}
		a[:external_id] = id.to_s
		fields = []

		title_f = {}
		title_f[:name] = "title"
		title_f[:value] = title
		title_f[:type] = "string"
		fields << title_f

		unless subtitles.blank? or subtitles.empty?
			sub_f = {}
			sub_f[:name] = "subtitle"
			sub_f[:value] = subtitles.flatten
			sub_f[:type] = "text"
			fields << sub_f
		end

		body_f = {}
		body_f[:name] = "body"
		body_f[:value] = body
		body_f[:type] = "text"
		fields << body_f

		authors_f = {}
		authors_f[:name] = "authors"
		authors_f[:value] = people.map(&:full_name)
		authors_f[:type] = "text"
		fields << authors_f

		updated_f = {}
		updated_f[:name] = "updated_at"
		updated_f[:value] = updated_at.iso8601
		updated_f[:type] = "date"
		fields << updated_f

		created_f = {}
		created_f[:name] = "created_at"
		created_f[:value] = created_at.iso8601
		created_f[:type] = "date"
		fields << created_f

		unless section.nil?
			section_f = {}
			section_f[:name] = "section"
			section_f[:value] = section.name
			section_f[:type] = "enum"
			fields << section_f
		end

		unless blog.nil?
			blog_f = {}
			blog_f[:name] = "blog"
			blog_f[:value] = blog.title
			blog_f[:type] = "enum"
			fields << blog_f
		end

		unless series.nil?
			series_f = {}
			series_f[:name] = "series"
			series_f[:value] = series.title
			series_f[:type] = "enum"
			fields << series_f
		end

		a[:fields] = fields

		return a
	end

	def pageview_count
		if views.nil? || views.zero?
			return pageviews.size
		else
			return pageviews.size + views
		end
	end

	def unique_pageview_count
		pageviews.to_a.group_by(&:encoded_ip_address).length
	end

	def event_day_str
		return 'This week' if event_day.nil?
		days = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
		days[10] = "Rest of the week: #{first_event.date_start.strftime('%A')}"
		return days[event_day]
	end

	def first_event
		events.first
	end

	def self.events_thursday
		where(:event_day => 4)
	end

	def self.events_friday
		where(:event_day => 5)
	end

	def self.events_saturday
		where(:event_day => 6)
	end

	def self.events_row
		where(:event_day => 10)
	end

	def twitter_shares
		social_shares.nil? ? 0 : (social_shares[:twitter].max || 0)
	end

	def fb_shares
		social_shares.nil? ? 0 : (social_shares[:fb].max || 0)
	end

	def total_social_shares
		if social_shares.blank?
			return 0
		else 
			return social_shares.map{|k,v| v.max}.sum
		end
	end

	def update_social_shares(network, share_count)
		net = network.to_sym
		ss = social_shares.nil? ? {} : social_shares
		if ss[net].nil?
			ss[net] = [share_count]
		else
			ss[net] << share_count
		end
		update_attribute(:social_shares, ss)
	end

	private
		def check_clean_title
			c = created_at
			a = Article.where(:cleantitle => cleantitle)
			cleantitle << "-#{a.count + 1}" if a.count > 1
		end

		def twitter_people
			if twitter_names.blank?
				return false
			else
				return " by #{twitter_names}"
			end
		end

		def update_queued_tweets
			SocialPost.where(article_id:id, in_queue:true).update_all(status_text: tweet)
		end

		def remove_associated_tweets
			SocialPost.where(article_id:id).destroy_all
		end

end
