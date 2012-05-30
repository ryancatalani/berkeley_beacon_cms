class Article < ActiveRecord::Base
	validates_presence_of :title, :body, :articletype
	attr_accessible :title, :body, :excerpt, :articletype, :people, :subtitles, :cleantitle, :series_id, :section_id, :archive, :archive_images
	has_many :authorships
	has_many :people, :through => :authorships
	has_many :taggings
	has_many :tags, :through => :taggings
	has_many :articlemediacontents
	has_many :mediafiles, :through => :articlemediacontents
	serialize :subtitles
	belongs_to :section
	belongs_to :series
	belongs_to :blog
	before_save :check_clean_title
	serialize :archive_images
	# default_scope :order => 'created_at DESC'
	
	def to_url
		c = created_at
		base = blog.nil? ? section.clean_url : blog.cleantitle
		"/#{base}/#{c.year}/#{c.month}/#{c.day}/#{cleantitle}"
	end
	
	def tweet
		t = title
		t = "From #{blog.title}: #{t}" if blog
		ret = "#{t.truncate(119, :separator => ' ')} http://berkeleybeacon.com#{to_url}"
		ret << twitter_people unless title.length + 20 + twitter_people.length > 140
		return ret
	end

	def first_photo
		return mediafiles.where(:mediatype => 1).first if mediafiles.count > 0
		return nil
	end

	def images
		mediafiles.where('mediatype <> 2')
	end
	
	# As SGA resignations increase, officials discuss term length requirement
	
	private
		def check_clean_title
			c = created_at
			a = Article.where(:cleantitle => cleantitle)
			cleantitle << "-#{a.count + 1}" if a.count > 1
		end
		
		def twitter_people
			if people.map{ |p| !p.twitter.blank? }.all?
				# all have twitter usernames
				t = people.map{ |p| "@#{p.twitter}" }
				ret = ' by '
				if t.count == 1
					ret << t.first
				elsif t.count == 2
					ret << t.join(' & ')
				else
					last = t.pop
					ret << t.join(' ')
					ret << " & #{last}"
				end
				return ret
			else
				# at least one doesn't have twitter username
				return ''
			end
				
		end
		
end
