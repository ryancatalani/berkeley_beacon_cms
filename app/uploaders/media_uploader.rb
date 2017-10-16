# encoding: utf-8

class MediaUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  def filename
    @name ||= "#{timestamp}-#{super}.jpg" if original_filename.present? and super.present?
  end

  def timestamp
    var = :"@#{mounted_as}_timestamp"
    model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_i)
  end

	# Popular story
	version :thumb_40, :if => :image? do
		process :resize_to_fill => [40,40]
	end

	# Featured stories, section box images
	version :thumb_220, :if => :image? do
		process :resize_to_fill => [220,220]
	end

	# Middle strip story
	version :thumb_140, :if => :image? do
		process :resize_to_fill => [140,140]
	end

	# Main story image
	version :thumb_460, :if => :image? do
		process :resize_to_fill => [460,460]
	end

  version :long_480, :if => :image? do
    process :resize_to_fit => [480, 480]
  end

  # To recreate, where m is a Mediafile
  # m.media.cache_stored_file!; m.media.retrieve_from_cache!(m.media.cache_name); m.media.recreate_versions!; m.save!

  protected

      def image?(new_file)
        new_file.content_type.include? 'image'
      end


  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # def store_dir
  #   "#{Rails.public_path}/system/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end

  def store_dir
    "beacon_uploads/uploads"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.


	# version :scaled do
	# 	process :resize_to_fit => [820, 820]
	# end

	protected

		# def is_landscape? picture
		# 	image = MiniMagick::Image.open(picture.path)
		# 	  	image[:width] > image[:height]
		# end

end
