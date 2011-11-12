class Article < ActiveRecord::Base
	validates_presence_of :title, :body, :type
end
