namespace :db do
	desc "Find most popular recent articles"
	task :find_popular_articles => :environment do

		popular = PopularSnapshot.new

		# Number of popular articles to display
		num = 5

		# --- Popular by views, i.e. most viewed

		num_days = 2
		pop_by_views = Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).where(:draft => [false, nil]).sort_by{|a| a.pageview_count }.reverse.first(num)
		while pop_by_views.count < num
			num_days += 1
			pop_by_views << Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).where(:draft => [false, nil]).sort_by{|a| a.pageview_count }.reverse.first(num)
			pop_by_views.flatten!
			pop_by_views.uniq!
		end
		pop_by_views_final = pop_by_views.first(num).sort_by{|a| a.pageview_count}.reverse
		popular.most_viewed = pop_by_views_final.map {|a| [a.id, a.pageview_count]}

		# --- Popular on Facebook and Twitter, i.e. most shared on social networks

		num_days = 2
		pop_social = []
		pop_social_candidates = {}

		pop_initial = Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).where(:draft => [false, nil])
		while pop_initial.count < num
			num_days += 7
			pop_initial = Article.where(:created_at => (Time.now.midnight - num_days.days)..(Time.now.midnight + 1.day)).where(:draft => [false, nil])
		end

		pop_urls = pop_initial.map {|a| a.to_url(:full => true)}
		pop_initial.each {|a| pop_social_candidates[a.to_url(:full=>true)] = {:id => a.id, :fb => 0, :twt => 0, :total => 0} }

		pop_urls.each do |url|

			sc_share_uri = URI.parse('http://free.sharedcount.com/url?apikey=***REMOVED***&url=' + url)
			sc_share_res = Net::HTTP.get_response(sc_share_uri).body
			sc_share_data = ActiveSupport::JSON.decode(sc_share_res)

			fb = sc_share_data["Facebook"]["total_count"].nil? ? 0 : sc_share_data["Facebook"]["total_count"]
			twitter = sc_share_data["Twitter"].nil? ? 0 : sc_share_data["Twitter"]

			pop_social_candidates[url][:fb] = fb
			pop_social_candidates[url][:twt] = twitter
			pop_social_candidates[url][:total] = pop_social_candidates[url][:fb] + twt_share_data["count"]

		end

		pop_social = pop_social_candidates.sort_by{|k,v| v[:total]}.reverse.first(5).map{ |a| [a[1][:id], a[1][:total]] }
		popular.most_shared = pop_social

		popular.save!


	end
end