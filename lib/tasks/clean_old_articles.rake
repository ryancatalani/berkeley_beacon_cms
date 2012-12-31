namespace :db do
	desc "Clean up old articles"
	task :clean_old_articles => :environment do
		include ActionView::Helpers::SanitizeHelper

		Article.where('body LIKE ?', '%/pp/pp%').each do |article|
			puts "#{article.id} starting"
			b = article.body
			b = b.gsub('/pp/pp','</p><p>')
			b = b.gsub('#44;',',')
			b = b.gsub('quot;','"')
			b = b.gsub('apos;',"'")
			b = b.gsub('[gallery]','')
			if b.first == 'p'
				b[0] = '<p>'
			elsif b.first(4) == '<p>p'
				b[0,4] = '<p>'
			end
			if b.last(2) == '/p'
				b[-2,2] = '</p>'
			elsif b.last(6) == '/p</p>'
				b[-6,6] = '</p>'
			end
			saved_body = article.update_attribute(:body, b)

			new_excerpt = strip_tags(b).truncate(100, :separator => ' ')
			saved_excerpt = article.update_attribute(:excerpt, new_excerpt)

			puts "#{article.id} completed / body: #{saved_body} excerpt: #{saved_excerpt}"
		end

	end
end