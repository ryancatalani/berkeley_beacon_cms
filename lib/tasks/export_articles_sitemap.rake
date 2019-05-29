require 'csv'

namespace :export do
	desc "Export articles sitemap"
	task :articles_sitemap => :environment do

		count = Article.count
		base_url = "https://berkeleybeaconarchives.s3.amazonaws.com"

		builder = Nokogiri::XML::Builder.new do |xml|
			xml.urlset("xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9", "xmlns:news" => "http://www.google.com/schemas/sitemap-news/0.9") do

				Article.order(created_at: :asc).each_with_index do |article, i|
					puts "#{i+1}/#{count}"

					slug = article.cleantitle
					section = article.export_section.downcase
					year = article.created_at.year.to_s
					month = article.created_at.month.to_s
					day = article.created_at.day.to_s
					full_url = [base_url, section, year, month, day, "#{slug}.html"].join("/")

					xml.url do
						xml.loc full_url
						xml['news'].news do
							xml['news'].publication do
								xml['news'].name "The Berkeley Beacon"
								xml['news'].language "en"
							end
							xml['news'].publication_date article.created_at.strftime("%Y-%m-%d")
							xml['news'].title article.title
						end
					end
				end

			end
		end

		File.open(Rails.root.join("archives", "sitemap_articles.xml"), "w") do |f|
			f.puts builder.to_xml
		end

	end
end