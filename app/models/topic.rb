class Topic < ActiveRecord::Base
	has_many :topicals
	has_many :articles, :through => :topicals
	validates :title, :presence => true

end
