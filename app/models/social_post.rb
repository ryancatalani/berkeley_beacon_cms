class SocialPost < ActiveRecord::Base
	attr_accessible :status_text, :time, :network
	validates :status_text, :time, :network, :presence => true
	belongs_to :article

	# Networks:
	# 1 => Twitter
	# 2 => Facebook
	# 3 => Tumblr

end
