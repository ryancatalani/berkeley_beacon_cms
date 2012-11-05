namespace :db do
	desc "Post scheduled social posts"
	task :post_scheduled_posts => :environment do
		posts = []
		SocialPost.ready_to_post.each do |post|
			t = Twitter.update(post.full_post)
			t_id = t.attrs["id_str"]
			posts << {:url => "https://twitter.com/BeaconUpdate/status/#{t_id}", :title => post.article.title, :text => post.full_post}
			post.update_attribute(:posted, true)
		end
		BeaconMailer.just_posted(posts).deliver
	end
end