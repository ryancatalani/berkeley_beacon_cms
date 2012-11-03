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
	serialize :subtitles
	belongs_to :section
	belongs_to :series
	belongs_to :blog
	before_save :check_clean_title
	serialize :archive_images
	
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
		ret = "#{t.truncate(119, :separator => ' ').strip}: #{to_url(:full=>true)}"
		ret << twitter_people unless title.length + 20 + twitter_people.length > 140
		return ret
	end

	def first_photo
		if images.count > 0 and !images.first.media.nil?
			return images.first 
		elsif mediafiles.count > 0
			return mediafiles.first
		end
		 return nil
		# return nil
	end

	def images
		mediafiles.where('mediatype <> 2')
	end

	def videos
		mediafiles.where(:mediatype => 2)
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
