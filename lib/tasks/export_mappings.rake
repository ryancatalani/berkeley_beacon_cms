require 'csv'

namespace :export do
	desc "Export series, topics, etc to CSV"
	task :mappings => :environment do

		final_mappings = []
		final_mappings_headers = %w(Type Title Description Slug Logo Filename NumberOfArticles)

		topics_series = Topic.all + Series.all

		topics_series.each do |current_ts|
			title = current_ts.title
			classname = current_ts.class.to_s.downcase

			puts "starting #{title}"

			fname = "#{classname}_#{title.parameterize}"

			articles = []
			articles_headers = {
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
				excerpt: :excerpt
			}

			current_ts.articles.all.each do |article|
				article_csv = []
				articles_headers.values.each do |method|
					begin
						article_csv << article.send(method)
					rescue
						puts "error: article #{article.id}: #{method}"
						article_csv << ''
					end
				end
				articles << article_csv
			end

			CSV.open(Rails.root.join("#{fname}.csv"), "w") do |csv|
				csv << articles_headers.keys
				articles.each do |row|
					csv << row
				end
			end

			logo = ''
			if classname == "series"
				logo = current_ts.logo
			end

			final_mappings << [
				classname,
				title,
				current_ts.description,
				current_ts.slug,
				logo,
				"#{fname}.csv",
				current_ts.articles.count
			]
		end

		CSV.open(Rails.root.join("mappings.csv"), "w") do |csv|
			csv << final_mappings_headers
			final_mappings.each do |row|
				csv << row
			end
		end

		# headers = {
		# 	title: :title,
		# 	subtitles: :export_subtitles,
		# 	authors: :export_authors,
		# 	created_date: :export_created_at,
		# 	modified_date: :export_updated_at,
		# 	slug: :cleantitle,
		# 	section: :export_section,
		# 	issue: :export_issue,
		# 	featured_image: :export_first_photo,
		# 	media_links: :export_mediafiles,
		# 	media_with_captions: :export_mediafile_captions,
		# 	excerpt: :excerpt,
		# 	body: :export_body,
		# 	full_html: :export_full_html
		# }

		

		# slice_size = 100

		# Article.order(created_at: :asc).each_slice(slice_size).with_index do |article_arr, i|
		# 	start_time = Time.now
		# 	fname = "articles_#{(i*slice_size)+1}-#{(i+1)*slice_size}"
		# 	final = []

		# 	puts "starting #{fname}"

		# 	article_arr.each do |article|
		# 		article_csv = []
		# 		headers.values.each do |method|
		# 			begin
		# 				article_csv << article.send(method)
		# 			rescue
		# 				puts "error: article #{article.id}: #{method}"
		# 				article_csv << ''
		# 			end
		# 		end
		# 		final << article_csv
		# 	end
			
		# 	CSV.open(Rails.root.join("#{fname}.csv"), "w") do |csv|
		# 		csv << headers.keys
		# 		final.each do |row|
		# 			csv << row
		# 		end
		# 	end

		# 	time_diff = Time.now-start_time
		# 	puts "finished in #{time_diff.round(2)} s (#{(time_diff/60.0).round(2)} min)"
		# 	puts ""

		# end


	end
end