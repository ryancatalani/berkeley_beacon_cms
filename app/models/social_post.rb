class SocialPost < ActiveRecord::Base
	attr_accessible :status_text, :post_time, :network, :posted, :in_queue
	validates :status_text, :network, :presence => true
	belongs_to :article

	# Networks:
	# 1 => Twitter
	# 2 => Facebook
	# 3 => Tumblr

	def self.networks
		[["Twitter", 1]]
	end

	def self.ready_to_post
		where(:posted => false, :post_time => (1.year.ago..(Time.now)))
	end

	def self.twitter_queue
		where(:in_queue => true, :posted => false)
	end

	def ready_to_post?
		!posted and post_time < Time.zone.now and !in_queue
	end

	def network_name
		networks = self.class.networks
		return networks[network-1][0]
	end

	def full_post
		if Article.exists?(article_id)

			if network == 1
				return status_text.gsub('?n=t&sp=BB',"?n=t&sp=#{id}")
			end

		else
			return "Article not found."
		end
	end

	def can_include_twitter_photo?
		# Recalculate with the correct length of the link
		real_length = status_text.split(' ').delete_if{ |w| w =~ /https?:\/\// }.length + 1 + 23
		article.first_photo && (real_length + 1 + 23 < 140) # Length of a 1 t.co link (for photo) and spaces
	end

	def twitter_photo_url
		article.first_photo.media.url
	end

end
