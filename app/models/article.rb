class Article < ActiveRecord::Base
	validates_presence_of :title, :body, :articletype
	attr_accessible :title, :body, :excerpt, :articletype, :people, :subtitles
	has_many :authorships
	has_many :people, :through => :authorships
	serialize :subtitles
	belongs_to :section
end
