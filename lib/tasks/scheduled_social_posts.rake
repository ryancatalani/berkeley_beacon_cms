namespace :db do
	desc "Post scheduled social posts"
	task :post_scheduled_posts => :environment do
		include ActionView::Helpers::ApplicationHelper
		
		if SocialPost.ready_to_post.count > 0
			posts = []
			SocialPost.ready_to_post.each do |post|
				t = current_twitter.update(post.full_post)
				t_id = t.attrs["id_str"]
				posts << {:url => "https://twitter.com/BeaconUpdate/status/#{t_id}", :title => post.article.title, :text => post.full_post}
				post.update_attribute(:posted, true)
			end
			BeaconMailer.just_posted(posts).deliver
		end
		if !(Time.zone.now.strftime("%A") == "Wednesday" && Time.zone.now.hour > 18) || (Time.zone.now.strftime("%A") == "Thursday" && Time.zone.now.hour < 6) and (Time.zone.now.hour > 9 and Time.zone.now.hour < 21) and SocialPost.twitter_queue.count > 0
			posts = []
			# num_to_post = ((20 - (Time.zone.now.hour - 9)).to_f.to_d / 12.to_f.to_d).ceil
			num_to_post = 2
			SocialPost.twitter_queue.to_a.shuffle.first(num_to_post).each do |post|
				t = current_twitter.update(post.full_post)
				t_id = t.attrs["id_str"]
				posts << {:url => "https://twitter.com/BeaconUpdate/status/#{t_id}", :title => post.article.title, :text => post.full_post}
				post.update_attribute(:posted, true)
			end
			BeaconMailer.just_posted(posts).deliver
		end
	end
end