class Article < ActiveRecord::Base
	validates_presence_of :title, :body, :articletype
	attr_accessible :title, :body, :excerpt, :articletype, :people, :subtitles, :cleantitle
	has_many :authorships
	has_many :people, :through => :authorships
	has_many :taggings
	has_many :tags, :through => :taggings
	serialize :subtitles
	belongs_to :section
	before_save :check_clean_title
	
	def to_url
		c = created_at
		"/#{section.clean_url}/#{c.year}/#{c.month}/#{c.day}/#{cleantitle}"
	end
	
	private
		def check_clean_title
			c = created_at
			a = Article.where(:cleantitle => cleantitle)
			cleantitle << "-#{a.count + 1}" if a.count > 1
		end
end
