class Mediafile < ActiveRecord::Base
	attr_accessible :title, :description, :mediatype, :media, :source
	mount_uploader :media, MediaUploader
	has_many :articlemediacontents
	has_many :articles, :through => :articlemediacontents
	has_many :attributions
	has_many :people, :through => :attributions
	
	# Types
	# 0 => Media
	# 1 => Photograph
	# 2 => Video
	# 3 => Graphic
	# 4 => Illustration
	
end
