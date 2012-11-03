class SocialPost < ActiveRecord::Base
	attr_accessible :status_text, :post_time, :network, :posted
	validates :status_text, :post_time, :network, :presence => true
	belongs_to :article

	# Networks:
	# 1 => Twitter
	# 2 => Facebook
	# 3 => Tumblr

	def self.networks
		[["Twitter", 1]]
	end

	def network_name
		networks = self.class.networks
		return networks[network-1][0]
	end

	def full_post
		if network == 1
			url = article.to_url_with_tracking('t', id)
			return "#{status_text} #{url}"
		end
	end

end
