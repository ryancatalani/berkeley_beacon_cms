class Article < ActiveRecord::Base
	validates_presence_of :title, :body, :articletype
	attr_accessible :title, :body, :excerpt, :articletype, :people, :subtitles, :cleantitle, :series_id, :section_id, :archive, :archive_images, :blog_id, :link_only, :link
	has_many :authorships
	has_many :people, :through => :authorships
	has_many :taggings
	has_many :tags, :through => :taggings
	has_many :articlemediacontents
	has_many :mediafiles, :through => :articlemediacontents
	has_many :social_posts
	has_many :pageviews, :as => :obj_pageviews
	belongs_to :section
	belongs_to :series
	belongs_to :blog
	serialize :archive_images
	serialize :subtitles
	before_save :check_clean_title

	def to_url(opts={})
		if link_only
			return link
		else
			c = created_at
			base = blog.nil? ? section.clean_url : blog.cleantitle
			path = "/#{base}/#{c.year}/#{c.month}/#{c.day}/#{cleantitle}"
			return "http://berkeleybeacon.com"+path if opts[:full] and opts[:full] = true
			return path
		end
	end

	def to_url_with_tracking(name,id)
		"#{to_url(:full=>true)}?n=#{name}&sp=#{id}"
	end

	def tweet
		t = title
		t = "From #{blog.title}: #{t}" if blog
		ret = "#{t.truncate(117, :separator => ' ').strip}: #{to_url(:full=>true)}"
		ret << twitter_people unless title.length + 23 + twitter_people.length > 140
		return ret
	end

	def first_photo
		if images.count > 0 and !images.first.media.nil?
			return images.first
		elsif visual_mediafiles.count > 0
			return visual_mediafiles.first
		end
		 return nil
		# return nil
	end

	def images
		mediafiles.where('mediatype <> 2 AND mediatype <> 5')
	end

	def videos
		mediafiles.where(:mediatype => 2)
	end

	def audio_files
		mediafiles.where(:mediatype => 5)
	end

	def visual_mediafiles
		mediafiles.where('mediatype <> 5')
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
		if people.map{ |p| !p.twitter.blank? }.all?
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

	private
		def check_clean_title
			c = created_at
			a = Article.where(:cleantitle => cleantitle)
			cleantitle << "-#{a.count + 1}" if a.count > 1
		end

		def twitter_people
			if twitter_names.blank?
				return ''
			else
				return " by #{twitter_names}"
			end
		end

end
