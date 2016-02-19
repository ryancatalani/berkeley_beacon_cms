class Person < ActiveRecord::Base
	include AlgoliaSearch

	has_secure_password
	has_many :authorships
	has_many :articles, :through => :authorships
	has_many :attributions
	has_many :mediafiles, :through => :attributions
	# validates_presence_of :password, :on => :create, :if => :is_editor?
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :firstname, 	:presence   => true,
                    		:length     => { :maximum => 254 }
  	validates :lastname, 	:presence   => true,
                    		:length     => { :maximum => 254 }

  	validates :email,	:presence   => true,
                    	:format     => { :with => email_regex },
                    	:uniqueness => { :case_sensitive => false },
                    	:length     => { :within => 4..254 }
  	mount_uploader :profile, ProfileUploader

  	algoliasearch per_environment: true do
  		attribute :full_name
  	end

	def is_editor?
		editor == true
	end

	def all_content
		begin
			ret = Attribution.where(:person_id => id).map{|a| a.mediafile}.map{|m| m.articles}.flatten.uniq
		rescue
			ret = []
		end
		ret << articles.all
		return ret.flatten.uniq
	end

	def official_name
		if other_designation.blank?
			"#{firstname} #{lastname} / Beacon #{staff? ? "Staff" : "Correspondent" }"
		else
			"#{firstname} #{lastname} #{other_designation == "*" ? "" : "/ #{other_designation}"}"
		end
	end

	def official_linked_name
		return "<a href='/staff/#{clean_full_name}/'>#{official_name}</a>"
	end

	def full_name
		"#{firstname} #{lastname}"
	end

	def designation
		return "Editor" if editor?
		return "Staff" if staff?
		return other_designation if !other_designation.blank? and other_designation != "*"
		return "" if !other_designation.blank? and other_designation == "*"
		return "Correspondent"
	end

	def pos
		return position if !position.blank?
		return "Beacon Staff" if staff?
		return other_designation if !other_designation.blank? and other_designation != "*"
		return "" if !other_designation.blank? and other_designation == "*"
		return "Beacon Correspondent"
	end

	def contact_info
		ret = "#{lastname} can be reached at <a href='mailto:#{email}'>#{email}</a>. "
		unless twitter.blank?
		  ret << "<br /><a href=\"https://twitter.com/#{twitter}\""
		  ret << ' class="twitter-follow-button" data-show-count="false" data-lang="en">Follow @'
		  ret << twitter
		  ret << '</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>'
		end
    # ret << "Follow #{lastname} on Twitter at <a href='http://twitter.com/#{twitter}'>@#{twitter}</a>. "
		return ret
	end

	def profile_video
		# To use same syntax as mediafile
		require 'ostruct'
		video_hash = {}
		video_hash[:mp4] = profile_video_mp4_url
		video_hash[:ogg] = profile_video_ogg_url
		video_hash[:webm] = profile_video_webm_url

		video = OpenStruct.new(video_hash)
		return video
	end

	def as_indexed_json(options={})
		as_json(methods: :full_name, only: :full_name)
	end

	def to_url
		"/staff/#{clean_full_name}"
	end

end
