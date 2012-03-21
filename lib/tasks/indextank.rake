namespace :db do
	desc "Populate indextank index"
	task :indextank => :environment do
		index_name = Rails.env.production? ? "idx_production" : "idx"
		puts "index name: #{index_name}"

		client = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'] || 'http://:y1GqHmgP0jH2lL@dphiu.api.searchify.com')
		index = client.indexes(index_name)

		begin
			articles = Rails.env.production? ? Article.all : Article.first(50)
			article_count = articles.count
			articles.each_with_index do |article,count|
				puts "Starting article #{article.id} (#{count+1}/#{article_count})"
				authors = article.people.map{|p| p.firstname+' '+p.lastname}.join(' ') rescue ''
				subtitles = article.subtitles.join('  ') rescue ''
				index.document(article.id).add({
					:text => article.body,
					:title => article.title,
					:authors => authors,
					:subtitles => subtitles,
					:timestamp => article.created_at.to_i
				})
			end
		rescue
			puts "Error: ",$!
		end

	end
end