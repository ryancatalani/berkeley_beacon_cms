namespace :db do
	desc "Post scheduled social posts"
	task :post_scheduled_posts => :environment do
		include ActionView::Helpers::ApplicationHelper

		# Override with rake db:post_scheduled_posts force=true
		if (Time.zone.now.hour >= 9 && Time.zone.now.hour < 21) || (ENV['force'] && ENV['force'] == 'true')
			to_post = []
			did_post = []

			# Override with rake db:post_scheduled_posts force=true force_print=true
			if (Time.zone.now.strftime("%A") == print_release_day) || (ENV['force_print'] && ENV['force_print'] == 'true')
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
				if post.can_include_twitter_photo?
					uri = URI.parse(post.twitter_photo_url)
					media = uri.open
					media.instance_eval("def original_filename; '#{File.basename(uri.path)}'; end")
					t = current_twitter.update_with_media(post.full_post, media)
				else
					t = current_twitter.update(post.full_post)
				end
				t_id = t.attrs["id_str"]
				did_post << {:url => "https://twitter.com/BeaconUpdate/status/#{t_id}", :title => post.article.title, :text => post.full_post}
				post.update_attribute(:posted, true)
			end

			if did_post.count > 0
				BeaconMailer.just_posted(did_post).deliver
			end

		end

	end
end