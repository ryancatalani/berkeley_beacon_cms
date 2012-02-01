class StylebookEntry < ActiveRecord::Base
	validates :body, :presence => true
	attr_accessible :body, :notes
end
