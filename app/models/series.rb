class Series < ActiveRecord::Base
	has_many :articles
	mount_uploader :logo, SeriesLogoUploader
end
