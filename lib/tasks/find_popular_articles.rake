namespace :db do
	desc "Find most popular recent articles"
	task :find_popular_articles => :environment do

		num = 5

		# num_days = 2
		# pop_by_views = Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).where(:draft => [false, nil]).order("views DESC").first(num)
		# while pop_by_views.count < num
		# 	num_days += 1
		# 	pop_by_views << Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).where(:draft => [false, nil]).order("views DESC").first(num)
		# 	pop_by_views.flatten!
		# 	pop_by_views.uniq!
		# end
		# pop_by_views_final = pop_by_views.first(num).sort_by{|a| a.views}.reverse


		num_days = 2
		pop_social = []
		pop_social_candidates = {}

		pop_initial = Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).where(:draft => [false, nil])
		if pop_initial.count < num
			num_days = 7
			pop_initial = Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).where(:draft => [false, nil])
		end

		pop_urls = pop_initial.map {|a| a.to_url(:full => true)}
		pop_urls.each {|url| pop_social_candidates[url] = {:fb => 0, :twt => 0}  }
		fb_shares_uri = URI.parse('http://graph.facebook.com/?ids=' + pop_urls.join(','))
		fb_shares_res = Net::HTTP.get_response(fb_shares_uri).body
		fb_shares_data = ActiveSupport::JSON.decode(fb_shares_res)
		fb_shares_data.each do |k,v|
			if v["shares"]
				pop_social_candidates[k][:fb] = v["shares"]
			end
		end

		pop_urls.each do |url|
			twt_share_uri = URI.parse('http://urls.api.twitter.com/1/urls/count.json?url=' + url)
			twt_share_res = Net::HTTP.get_response(twt_share_uri).body
			twt_share_data = ActiveSupport::JSON.decode(twt_share_res)
			pop_social_candidates[url][:twt] = twt_share_data["count"]
		end

		puts pop_social_candidates

		# while pop_social.count < num
		# 	num_days += 1
		# 	pop_social << Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).where(:draft => [false, nil]).order("views DESC").first(num)
		# 	pop_social.flatten!
		# 	pop_social.uniq!
		# end
		# pop_social_final = pop_social.first(num).sort_by{|a| a.views}.reverse		

	end
end