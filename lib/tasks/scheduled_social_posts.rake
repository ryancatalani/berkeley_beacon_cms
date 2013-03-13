namespace :db do
	desc "Post scheduled social posts"
	task :post_scheduled_posts => :environment do
		include ActionView::Helpers::ApplicationHelper

		if Time.zone.now.hour > 9 and Time.zone.now.hour < 21 || (ENV['force'] && ENV['force'] == 'true')
			to_post = []
			did_post = []

			if Time.zone.now.strftime("%A") == print_release_day || (ENV['force'] && ENV['force'] == 'true')
				if SocialPost.twitter_queue.count > 0
					num_to_post = 2
					to_post = SocialPost.twitter_queue.to_a.shuffle.first(num_to_post)
				end
			else
				if SocialPost.ready_to_post.count > 0
					to_post = SocialPost.ready_to_post
				end
			end

			to_post.each do |post|
				t = current_twitter.update(post.full_post)
				t_id = t.attrs["id_str"]
				did_post << {:url => "https://twitter.com/BeaconUpdate/status/#{t_id}", :title => post.article.title, :text => post.full_post}
				post.update_attribute(:posted, true)
			end

			BeaconMailer.just_posted(did_post).deliver
		end

	end
end