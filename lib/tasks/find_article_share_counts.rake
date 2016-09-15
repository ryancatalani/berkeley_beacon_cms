namespace :articles do
	desc "Find most popular recent articles"
	task :find_share_counts => :environment do

		searching_issue = Issue.latest
		if !ENV['issue'].blank?
			searching_issue = Issue.find_by_release_date(Date.parse(ENV['issue']))
			raise 'Cannot find that issue.' if searching_issue.nil?
		end

		searching_articles = searching_issue.articles
		searching_articles << Article.where(created_at: searching_issue.release_date.midnight..(searching_issue.release_date+1.week).midnight)

		searching_articles.each do |article|
			url = article.to_url(full: true)

			sc_share_uri = URI.parse('http://free.sharedcount.com/url?apikey=***REMOVED***&url=' + url)
			sc_share_res = Net::HTTP.get_response(sc_share_uri).body
			sc_share_data = ActiveSupport::JSON.decode(sc_share_res)

			# fb = sc_share_data["Facebook"]["total_count"].nil? ? 0 : sc_share_data["Facebook"]["total_count"]
			fb = 0
			twitter = sc_share_data["Twitter"].nil? ? 0 : sc_share_data["Twitter"]

			article.update_social_shares(:fb, fb)
			article.update_social_shares(:twitter, twitter)

		end


	end
end