require 'csv'

namespace :export do
	desc "Export articles to CSV"
	task :articles => :environment do

		headers = {
			title: :title,
			subtitles: :export_subtitles,
			authors: :export_authors,
			created_date: :export_created_at,
			modified_date: :export_updated_at,
			slug: :cleantitle,
			section: :export_section,
			issue: :export_issue,
			featured_image: :export_first_photo,
			media_links: :export_mediafiles,
			media_with_captions: :export_mediafile_captions,
			excerpt: :excerpt,
			body: :export_body,
			full_html: :export_full_html
		}

		

		slice_size = 100

		Article.order(created_at: :asc).each_slice(slice_size).with_index do |article_arr, i|
			start_time = Time.now
			fname = "articles_#{(i*slice_size)+1}-#{(i+1)*slice_size}"
			final = []

			puts "starting #{fname}"

			article_arr.each do |article|
				article_csv = []
				headers.values.each do |method|
					begin
						article_csv << article.send(method)
					rescue
						puts "error: article #{article.id}: #{method}"
						article_csv << ''
					end
				end
				final << article_csv
			end
			
			CSV.open(Rails.root.join("#{fname}.csv"), "w") do |csv|
				csv << headers.keys
				final.each do |row|
					csv << row
				end
			end

			time_diff = Time.now-start_time
			puts "finished in #{time_diff.round(2)} s (#{(time_diff/60.0).round(2)} min)"
			puts ""

		end


	end
end