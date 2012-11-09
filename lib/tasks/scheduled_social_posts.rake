namespace :db do
	desc "Post scheduled social posts"
	task :post_scheduled_posts => :environment do
		if SocialPost.ready_to_post.count > 0
			posts = []
			SocialPost.ready_to_post.each do |post|
				t = Twitter.update(post.full_post)
				t_id = t.attrs["id_str"]
				posts << {:url => "https://twitter.com/BeaconUpdate/status/#{t_id}", :title => post.article.title, :text => post.full_post}
				post.update_attribute(:posted, true)
			end
			BeaconMailer.just_posted(posts).deliver
		end
		if !(Time.now.strftime("%A") == "Wednesday" && Time.now.hour > 18) || (Time.now.strftime("%A") == "Thursday" && Time.now.hour < 6) and SocialPost.twitter_queue.count > 0
			posts = []
			num_to_post = ((20 - (Time.now.hour - 9)).to_d / 12.to_d).ceil
			SocialPost.twitter_queue.to_a.shuffle.first(num_to_post).each do |post|
				t = Twitter.update(post.full_post)
				t_id = t.attrs["id_str"]
				posts << {:url => "https://twitter.com/BeaconUpdate/status/#{t_id}", :title => post.article.title, :text => post.full_post}
				post.update_attribute(:posted, true)
			end
			BeaconMailer.just_posted(posts).deliver
		end
	end
end