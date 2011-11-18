class Articlemediacontent < ActiveRecord::Base
	belongs_to :article
	belongs_to :mediafile
end
