namespace :db do
	desc "Clean up old articles"
	task :clean_old_articles => :environment do

		Article.where('body LIKE ?', '%/pp/pp%').first(25).each do |article|
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
			saved = article.update_attribute(:body, b)
			puts "#{article.id} completed #{saved}"
		end

	end
end