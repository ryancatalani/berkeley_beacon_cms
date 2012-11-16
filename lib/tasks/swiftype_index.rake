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
			m = {}
			m[:external_id] = mediafile.id.to_s
			fields = []

			title_f = {}
			title_f[:name] = "title"
			title_f[:value] = mediafile.title
			title_f[:type] = "string"
			fields << title_f

			article_titles_f = {}
			article_titles_f[:name] = "article_titles"
			article_titles_f[:value] = mediafile.articles.map(&:title)
			article_titles_f[:type] = "text"
			fields << article_titles_f

			creators_f = {}
			creators_f[:name] = "creators"
			creators_f[:value] = mediafile.people.map(&:full_name)
			creators_f[:type] = "text"
			fields << creators_f

			updated_f = {}
			updated_f[:name] = "updated_at"
			updated_f[:value] = mediafile.updated_at.iso8601
			updated_f[:type] = "date"
			fields << updated_f

			created_f = {}
			created_f[:name] = "created_at"
			created_f[:value] = mediafile.created_at.iso8601
			created_f[:type] = "date"
			fields << created_f

			type_f = {}
			type_f[:name] = "mediatype"
			type_f[:value] = mediafile.mediatype_str
			type_f[:type] = "enum"
			fields << type_f

			m[:fields] = fields
			to_index_media << m
		end




		to_index = []
		Article.all.each do |article|
			a = {}
			a[:external_id] = article.id.to_s
			fields = []

			title_f = {}
			title_f[:name] = "title"
			title_f[:value] = article.title
			title_f[:type] = "string"
			fields << title_f

			unless article.subtitles.blank? or article.subtitles.empty?
				sub_f = {}
				sub_f[:name] = "subtitle"
				sub_f[:value] = article.subtitles.flatten
				sub_f[:type] = "text"
				fields << sub_f
			end

			body_f = {}
			body_f[:name] = "body"
			body_f[:value] = article.body
			body_f[:type] = "text"
			fields << body_f

			authors_f = {}
			authors_f[:name] = "authors"
			authors_f[:value] = article.people.map(&:full_name)
			authors_f[:type] = "text"
			fields << authors_f

			updated_f = {}
			updated_f[:name] = "updated_at"
			updated_f[:value] = article.updated_at.iso8601
			updated_f[:type] = "date"
			fields << updated_f

			created_f = {}
			created_f[:name] = "created_at"
			created_f[:value] = article.created_at.iso8601
			created_f[:type] = "date"
			fields << created_f

			unless article.section.nil?
				section_f = {}
				section_f[:name] = "section"
				section_f[:value] = article.section.name
				section_f[:type] = "enum"
				fields << section_f
			end

			unless article.blog.nil?
				blog_f = {}
				blog_f[:name] = "blog"
				blog_f[:value] = article.blog.title
				blog_f[:type] = "enum"
				fields << blog_f
			end

			unless article.series.nil?
				series_f = {}
				series_f[:name] = "series"
				series_f[:value] = article.series.title
				series_f[:type] = "enum"
				fields << series_f
			end

			a[:fields] = fields
			to_index << a
		end

		article_type.create_documents(to_index)
		mediafile_type.create_documents(to_index_media)



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