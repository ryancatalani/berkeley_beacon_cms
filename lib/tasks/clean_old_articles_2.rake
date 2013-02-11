namespace :db do
	desc "Clean up old articles 2 - different stuff this time"
	task :clean_old_articles_2 => :environment do
		include ActionView::Helpers::SanitizeHelper

		Article.where('body LIKE ?', '%br /br /%').each do |article|
			puts "#{article.id} starting"
			b = article.body
			b = b.gsub('br /br /','</p><p>')
			b = b.gsub(/ldquo;|rdquo;/,'"')
			b = b.gsub('rsquo;',"'")
			b = b.gsub('/span','')
			b = b.gsub(/[^\/]span.*?;"/, '')
			unless b.first == '<p>'
				b[0] = '<p>'
			end
			unless b.last(4) == '</p>'
				b[-2,2] = '</p>'
			end

			saved_body = article.update_attribute(:body, b)

			new_excerpt = strip_tags(b).truncate(100, :separator => ' ')
			saved_excerpt = article.update_attribute(:excerpt, new_excerpt)

			puts "#{article.id} completed / body: #{saved_body} excerpt: #{saved_excerpt}"
		end

	end
end