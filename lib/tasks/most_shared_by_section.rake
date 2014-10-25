namespace :db do
	desc "Find most popular recent articles"
	task :find_section_shares => :environment do

		searching_issue = Issue.latest
		if !ENV['issue'].blank?
			searching_issue = Issue.find_by_release_date(Date.parse(ENV['issue']))
			raise 'Cannot find that issue.' if searching_issue.nil?
		end

		searching_issue_articles = searching_issue.articles.map {|a| {article: a, url: a.to_url(full: true)} }

		section_shares = {
			'news' => {twitter: 0, facebook: 0, total: 0},
			'opinion' => {twitter: 0, facebook: 0, total: 0},
			'arts' => {twitter: 0, facebook: 0, total: 0},
			'lifestyle' => {twitter: 0, facebook: 0, total: 0},
			'sports' => {twitter: 0, facebook: 0, total: 0},
			'feature' => {twitter: 0, facebook: 0, total: 0},
			'events' => {twitter: 0, facebook: 0, total: 0},
			'beyond' => {twitter: 0, facebook: 0, total: 0}
		}

		searching_issue_articles.each do |article_hash|
			# -- based on find_popular_articles.rake -- 
			url = article_hash[:url]
			section = article_hash[:article].section.name.downcase

			# Facebook
			fb_shares_uri = URI.parse(URI.escape("https://graph.facebook.com/fql?q=SELECT url, total_count FROM link_stat WHERE url='#{url}'"))
			fb_http = Net::HTTP.new(fb_shares_uri.host, fb_shares_uri.port)
			fb_http.use_ssl = true
			fb_http.verify_mode = Rails.env.production? ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE
			fb_request = Net::HTTP::Get.new(fb_shares_uri.request_uri)
			fb_shares_res = fb_http.request(fb_request)
			fb_shares_data = ActiveSupport::JSON.decode(fb_shares_res.body)
			if fb_shares_data["data"] && fb_shares_data["data"][0]["total_count"]
				fb_total = fb_shares_data["data"][0]["total_count"]
				section_shares[section][:facebook] += fb_total
				section_shares[section][:total] += fb_total
			end

			# Twitter
			twt_share_uri = URI.parse('http://urls.api.twitter.com/1/urls/count.json?url=' + url)
			twt_share_res = Net::HTTP.get_response(twt_share_uri).body
			twt_share_data = ActiveSupport::JSON.decode(twt_share_res)
			twt_total = twt_share_data["count"]
			section_shares[section][:twitter] += twt_total
			section_shares[section][:total] += twt_total
			
		end

		searching_issue.update_attribute(:section_shares, section_shares)

	end
end