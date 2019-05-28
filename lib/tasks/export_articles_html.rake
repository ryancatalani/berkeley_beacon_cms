require 'csv'

namespace :export do
	desc "Export articles to CSV"
	task :articles_html => :environment do

		count = Article.count

		Article.order(created_at: :asc).each_with_index do |article, i|
			puts "#{i}/#{count}"
			begin
				slug = article.cleantitle
				section = article.export_section
				year = article.created_at.year.to_s
				month = article.created_at.month.to_s
				day = article.created_at.day.to_s

				html = article.export_full_html
				noko = Nokogiri::HTML(html)
				noko.css("a").each do |link|
					href = link["href"]
					if !href.blank?
						if href =~ /^\/\w+/
							# Starts with slash (relative directory)
							link["href"] = href.gsub(/\/$/,"").concat(".html")
						elsif href =~ /^https?:\/\/(www\.)?berkeleybeacon\.com/
							# Starts with berkeleybeacon.com
							link["href"] = href.gsub(/https?:\/\/(www\.)?berkeleybeacon\.com/,"").gsub(/\/$/,"").concat(".html")
						end
					end
				end

				FileUtils.mkdir_p (Rails.root.join("archives", section, year, month, day))
				File.open(Rails.root.join("archives", section, year, month, day, "#{slug}.html"), "w") do |f|
					f.puts noko.to_s
				end

			rescue StandardError => e
				puts "error: article #{article.id}; #{e}"
			end

		end

	end
end