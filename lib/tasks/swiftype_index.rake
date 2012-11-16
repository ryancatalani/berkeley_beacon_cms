namespace :db do
	desc "Add documents to Swiftype index"
	task :create_swiftype_index => :environment do
		engine_slug = Rails.env.production? ? "berkeleybeacon" : "berkeleybeaconsandbox"
		engine = Swiftype::Engine.find(engine_slug)
		article_type = engine.document_type('articles')
		mediafile_type = engine.document_type('mediafiles')


		to_index_media = []
		Mediafile.all.each do |mediafile|
			next if mediafile.articles.empty?
			to_index_media << mediafile.indexable_info
		end

		to_index = []
		Article.all.each do |article|
			to_index << article.indexable_info
		end

		# article_type.create_documents(to_index)
		# mediafile_type.create_documents(to_index_media)

		i = 0
		slice_size = 100

		to_index.each_slice(slice_size) do |slice|
			puts i
			article_type.create_documents(slice)
			i += slice_size
		end

		i = 0
		to_index_media.each_slice(slice_size) do |slice|
			puts i
			mediafile_type.create_documents(slice)
			i += slice_size
		end


		to_index.each do |doc|
			# puts doc
			# type.create_document(doc)

			# puts doc.to_json
			# puts ''
		end

	end
end