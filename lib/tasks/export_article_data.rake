namespace :articles do
	desc "Export pageview and social media information"
	task :export_view_share_data => :environment do

		results = []

		date_start = ENV['issue'].blank? ? "2014-09-03" : ENV['issue']

		Article.where(draft: false, created_at: Date.parse(date_start).midnight..Time.now).each do |article|
			url = article.to_url(full: true)

			sc_share_uri = URI.parse("http://free.sharedcount.com/url?apikey=#{ENV['SHARED_COUNT_API_KEY']}&url=" + url)
			sc_share_res = Net::HTTP.get_response(sc_share_uri).body
			sc_share_data = ActiveSupport::JSON.decode(sc_share_res)

			fb = sc_share_data["Facebook"]["total_count"] || 0
			twitter = sc_share_data["Twitter"] || 0

			title = '"' + article.title.gsub('"',"'") + '"'
			section = article.section.name
			date = article.created_at.strftime('%B %e %Y')
			pageviews = article.pageview_count

			results << [title, url, section, date, pageviews, fb, twitter]
		end

		puts '--'
		results.each do |result|
			puts result.join(',')
		end

	end
end