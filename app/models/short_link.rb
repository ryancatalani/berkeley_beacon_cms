class ShortLink < ActiveRecord::Base

	attr_accessible :prefix, :link_text, :destination
	validates :link_text, :uniqueness => { :scope => :prefix }

	def full_path
		"#{prefix}/#{link_text}"
	end

end
