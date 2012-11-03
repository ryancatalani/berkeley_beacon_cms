namespace :db do
	desc "Post scheduled social posts"
	task :post_scheduled_posts => :environment do
		SocialPost.ready_to_post.each do |post|
			Twitter.update(post.full_post)
			post.update_attribute(:posted, true)
		end
	end
end