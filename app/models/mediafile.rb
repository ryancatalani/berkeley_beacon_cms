class Mediafile < ActiveRecord::Base
	attr_accessible :title, :description, :mediatype
	mount_uploader :media, MediaUploader
	has_many :articlemediacontents
	has_many :articles, :through => :articlemediacontents
end
