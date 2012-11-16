class Mediafile < ActiveRecord::Base
	attr_accessible :title, :description, :mediatype, :media, :source,
		:video_webm, :video_mp4, :video_ogg,
		:remote_video_mp4_url, :remote_video_ogg_url, :remote_video_webm_url,
		:direct_mp4_url, :direct_ogg_url, :direct_webm_url, :series_id
	mount_uploader :media, MediaUploader
	mount_uploader :video_mp4, MediaUploader
	mount_uploader :video_ogg, MediaUploader
	mount_uploader :video_webm, MediaUploader
	has_many :articlemediacontents
	has_many :articles, :through => :articlemediacontents
	has_many :attributions
	has_many :people, :through => :attributions
	belongs_to :series
	
	# Types
	# 0 => Media
	# 1 => Photograph
	# 2 => Video
	# 3 => Graphic
	# 4 => Illustration

	def mediatype_str
		if mediatype and mediatype <= 4
			return %w(Media Photograph Video Graphic Illustration)[mediatype]
		end
		return "Media"
	end

	def mp4
		return video_mp4.url if video_mp4.url
		return direct_mp4_url if direct_mp4_url
		return nil
	end

	def ogg
		return video_ogg.url  if video_ogg.url
		return direct_ogg_url if direct_ogg_url
		return nil
	end

	def webm
		return video_webm.url if video_webm.url
		return direct_webm_url if direct_webm_url
		return nil
	end

	def latest_article
		return articles.first if !articles.empty?
		return Article.last if articles.empty? and Rails.env.development?
	end

	def has_image?
		!media.nil?
	end

	def is_new?
		created_at > 7.days.ago
	end

	
end
