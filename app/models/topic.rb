class Topic < ActiveRecord::Base
	has_many :topicals
	has_many :articles, :through => :topicals
	validates :title, :presence => true
	before_save :create_slug

	private

	def create_slug
		slug = title.downcase.gsub(' ','-').gsub(/\W/,'')
	end
end
