namespace :articles do
	desc "Find most popular recent articles"
	task :find_share_counts => :environment do

		searching_issue = Issue.latest
		if !ENV['issue'].blank?
			searching_issue = Issue.find_by_release_date(Date.parse(ENV['issue']))
			raise 'Cannot find that issue.' if searching_issue.nil?
		end

		fb_graph = Koala::Facebook::API.new(ENV['KOALA_FB_API_KEY'])

		searching_articles = searching_issue.articles
		searching_articles << Article.where(created_at: searching_issue.release_date.midnight..(searching_issue.release_date+1.week).midnight)

		searching_articles.each do |article|
			url = article.to_url(full: true)

			sc_share_uri = URI.parse("http://free.sharedcount.com/url?apikey=#{ENV['SHARED_COUNT_API_KEY']}&url=" + url)
			sc_share_res = Net::HTTP.get_response(sc_share_uri).body
			sc_share_data = ActiveSupport::JSON.decode(sc_share_res)

			twitter = sc_share_data["Twitter"].nil? ? 0 : sc_share_data["Twitter"]

			fb = 0			
			begin
				fb_obj = fb_graph.get_object(CGI.escape(url))
				fb = fb_obj["share"]["share_count"]
			rescue
			end

			article.update_social_shares(:fb, fb)
			article.update_social_shares(:twitter, twitter)

		end


	end
end