class Mediafile < ActiveRecord::Base
	attr_accessible :title, :description, :mediatype, :media, :source,
		:video_webm, :video_mp4, :video_ogg,
		:remote_video_mp4_url, :remote_video_ogg_url, :remote_video_webm_url,
		:direct_mp4_url, :direct_ogg_url, :direct_webm_url, :series_id,
		:direct_audio_mp3_url, :direct_audio_ogg_url
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
	# 5 => Audio

	def mediatype_str
		if mediatype and mediatype <= 4
			return %w(Media Photograph Video Graphic Illustration Audio)[mediatype]
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
		return direct_audio_ogg_url if direct_audio_ogg_url
		return nil
	end

	def webm
		return video_webm.url if video_webm.url
		return direct_webm_url if direct_webm_url
		return nil
	end

	def mp3
		return direct_audio_mp3_url if direct_audio_mp3_url
		return nil
	end

	def latest_article
		return articles.first if !articles.empty?
	end

	def has_image?
		mediatype != 5 and !media.nil?
	end

	def is_new?
		created_at > 7.days.ago
	end

	def indexable_info
		m = {}
		m[:external_id] = id.to_s
		fields = []

		title_f = {}
		title_f[:name] = "title"
		title_f[:value] = title
		title_f[:type] = "string"
		fields << title_f

		article_titles_f = {}
		article_titles_f[:name] = "article_titles"
		article_titles_f[:value] = articles.map(&:title)
		article_titles_f[:type] = "text"
		fields << article_titles_f

		creators_f = {}
		creators_f[:name] = "creators"
		creators_f[:value] = people.map(&:full_name)
		creators_f[:type] = "text"
		fields << creators_f

		updated_f = {}
		updated_f[:name] = "updated_at"
		updated_f[:value] = updated_at.iso8601
		updated_f[:type] = "date"
		fields << updated_f

		created_f = {}
		created_f[:name] = "created_at"
		created_f[:value] = created_at.iso8601
		created_f[:type] = "date"
		fields << created_f

		type_f = {}
		type_f[:name] = "mediatype"
		type_f[:value] = mediatype_str
		type_f[:type] = "enum"
		fields << type_f

		m[:fields] = fields

		return m
	end

	def check_dimensions
		# begin
			image = MiniMagick::Image.open(media.url)
			dims_str = image["%w %h"]
			dims = dims_str.split(' ').map(&:to_i)
			if dims[1] > dims[0]
				update_attribute(:horizontal, false)
			end
		# rescue
			# Don't change the horizontal attribute.
		# end
	end

	def aspect_ratio_str
		horizontal? ? "horizontal" : "vertical"
	end

end
