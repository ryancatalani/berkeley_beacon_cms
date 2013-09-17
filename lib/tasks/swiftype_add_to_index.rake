namespace :db do
	desc "Add new documents to Swiftype index"
	task :update_swiftype_index => :environment do
		engine_slug = Rails.env.production? ? "berkeleybeacon" : "berkeleybeaconsandbox"
		engine = Swiftype::Engine.find(engine_slug)
		article_type = engine.document_type('articles')
		mediafile_type = engine.document_type('mediafiles')

		article_max = [700, Article.count].min
		mediafile_max = [300, Mediafile.count].min

		# To see if articles/mediafiles need to be added to index, see if last article/mediafile is in index
		last_article_search = article_type.search(Article.last.id, :search_fields => {:articles => ['external_id']})
		should_index_articles = last_article_search.records['articles'].count == 0
		last_mediafile_search = mediafile_type.search(Mediafile.last.id, :search_fields => {:mediafiles => ['external_id']})
		should_index_mediafiles = last_mediafile_search.records['mediafiles'].count == 0

		if should_index_mediafiles

			to_index_media = []
			number_to_index = mediafile_max - mediafile_type.document_count

			Mediafile.last(number_to_index).each do |mediafile|
				next if mediafile.articles.empty?
				to_index_media << mediafile.indexable_info
			end

			mediafile_type.create_documents(to_index_media)

		end # should_index_mediafiles


		if should_index_articles

			to_index = []
			number_to_index = article_max - article_type.document_count

			Article.last(number_to_index).each do |article|
				to_index << article.indexable_info
			end

			article_type.create_documents(to_index)

		end # should_index_articles




		# i = 0
		# slice_size = 25
		# to_index.each_slice(slice_size) do |slice|
		# 	puts i
		# 	type.create_documents(slice)
		# 	i += slice_size
		# end

		to_index.each do |doc|
			# puts doc
			# type.create_document(doc)

			# puts doc.to_json
			# puts ''
		end

	end
end