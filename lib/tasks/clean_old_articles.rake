namespace :db do
	desc "Clean up old articles"
	task :clean_old_articles => :environment do

		Article.where('body LIKE ?', '%/pp/pp%').all.each do |article|
			puts "#{article.id} starting"
			body = article.body
			body.gsub!('/pp/pp','</p><p>')
			body.gsub!('#44',',')
			body.gsub!('quot;','"')
			body.gsub!('apos;',"'")
			body.gsub!('[gallery]','')
			if body.first == 'p'
				body[0] = '<p>'
			elsif body.first(4) == '<p>p'
				body[0,4] = '<p>'
			end
			if body.last(2) == '/p'
				body[-2,2] = '</p>'
			elsif body.last(6) == '/p</p>'
				body[-6,6] = '</p>'
			end
			article.update_attribute(:body, body)
			puts "#{article.id} completed"
		end

	end
end