class ShortLink < ActiveRecord::Base

	validates :link_text, :uniqueness => { :scope => :prefix }

	def full_path
		"#{prefix}/#{link_text}"
	end

end
