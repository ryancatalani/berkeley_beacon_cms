class StylebookEntry < ActiveRecord::Base
	validates :body, :presence => true
end
