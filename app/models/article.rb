class Article < ActiveRecord::Base
	validates_presence_of :title, :body, :articletype
	attr_accessible :title, :body, :excerpt, :articletype, :people
	has_many :authorships
	has_many :people, :through => :authorships
end
