class Series < ActiveRecord::Base
	has_many :articles
	has_many :mediafiles
	mount_uploader :logo, SeriesLogoUploader
end
