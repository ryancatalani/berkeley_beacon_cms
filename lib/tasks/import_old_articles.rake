namespace :db do
	desc "Import old articles"
	task :import_old_articles => :environment do
		
		file = File.open(Rails.root.join("protected/articles.json"))
		json = ActiveSupport::JSON.decode(file)
		article = Article.new
		dt = Date.new
		
		no_author_count = 0
		short_excerpt_count = 0
		
		json.each_with_index do |(article_id, article_vals),index|
			puts index
			no_author = false
			short_excerpt = false
			student_of_the_week = false
			
			terms = article_vals["terms"]
			section_id = 1
			terms.each do |t|
				n = t["name"]
				if n.include?("News")
					section_id = Section.find_by_name("News").id
				elsif n.include?("Arts")
					section_id = Section.find_by_name("Arts & Entertainment").id
				elsif n.include?("Opinion")
					section_id = Section.find_by_name("Opinion").id
				elsif n.include?("Sports")
					section_id = Section.find_by_name("Sports").id
				elsif n.include?("Lifestyle")
					section_id = Section.find_by_name("Lifestyle").id
				elsif n.include?("Student of the Week")
					student_of_the_week = true
				else
					section_id = Section.find_by_name("News").id
				end
			end				
			
			
			title = article_vals["title"]
			cleantitle = title.strip.downcase.gsub(/[^A-z0-9\s]/,'').split(' ').first(8).join('-')
			
			body = article_vals["body"].gsub(/<!--.*-->/,'')
			
			imgs = body.split(/\[\/?caption/)
			if imgs.count > 1
				imgs.each do |img|
					if img.include?("href")
						begin
							img_caption = img.match(/caption="(.+?)"/)[1]
						rescue
							puts "SOME IMG CAPTION PARSE ERROR"
							img_caption = ''
							puts img
						end
						begin
							img_href = img.match(/href="(.+?)"/)[1]
						rescue
							puts "SOME IMG HREF PARSE ERROR"
							img_href = ''
							puts img
						end
						puts "img_caption = #{img_caption}, img_href = #{img_href}"
						# puts captions.to_a
					end
				end
			end
			
			video = /\[video.*\]/.match(body)
			unless video.nil?
				begin
					video_src = video.to_s.match(/mp4="(.+?)"/)[1]
					puts "video_src is #{video_src}"
				rescue
					puts "SOME VIDEO PARSE ERROR"
					puts video
				end
			end
			
			author, content = body.gsub(/\[caption.*?\].*?\[\/caption\]/,'').split("</strong>",2)
			if !author.nil? and author.include?("Beacon")
				author_and_des = author.split("<strong>",2).pop.gsub(/<.*?>/,'').strip
				auth, des = author_and_des.split(',')
				firstname, lastname = auth.split(' ',2)
				puts "author firstname is #{firstname}, lastname is #{lastname}, designation is #{des}"
			elsif !author.nil? and author.include?("Editorial Staff")
				firstname, lastname, des = ['Editorial','Board','Beacon Staff']
				puts "author firstname is #{firstname}, lastname is #{lastname}, designation is #{des}"
			else
				no_author = true
			end
			
			content = body if content.blank?
			
			if content.blank?
				puts "this is blank"
				puts ""
				next
			end
			
			contributor = /.*contributed reporting./.match(content).to_s.gsub(/, contributed reporting.*/,'').gsub(/<.*>/,'')
			if !contributor.nil? and contributor.include?("Beacon")
				contr, contr_des = contributor.split(',')
				contr_first, contr_last = contr.split(' ',2)
				puts "contributor's first name is #{contr_first}, last is #{contr_last}, desig is #{contr_des}"
			end
			
			# content = content.split(/^.*>/,2).last.strip
			content = content.gsub(/<.*?>/,'')
			content = content.gsub(/\[caption.*?\].*?\[\/caption\]/,'')
			content = content.gsub(/\[video.*?\]/,'')
			content = content.gsub('&nbsp;','')
			content = content.strip		
			
			if student_of_the_week
				firstname, lastname = content.split(' ').last(2)
				firstname = firstname.gsub(/\W/,'')
				des = '*'
				puts "author firstname is #{firstname}, lastname is #{lastname}, designation is #{des}"
				no_author = false
			end
			
			if content.include?("Auntie Em")
				firstname, lastname, des = ['Auntie','Em','*']
				puts "author firstname is #{firstname}, lastname is #{lastname}, designation is #{des}"
				no_author = false
			end
				
			content = '<p>' + content + '</p>'
			content = content.gsub(/\n\n/,'</p><p>').gsub(/\n/,'<br/>')
			
			
			excerpt = content.first(200).split(' ').first(18).join(' ').concat('...').gsub(/<.*?>/,'')
			short_excerpt = true if excerpt.length < 90
			puts '-- excerpt --'
			puts excerpt
			# puts '-- body --'
			# puts body.first(500)
			puts '-- content --'
			puts content.first(300)
							
			if no_author
				puts "NO AUTHOR"
				no_author_count += 1
			end
			if short_excerpt
				puts "SHORT EXCERPT" 
				short_excerpt_count += 1
			end
			puts ''
						
		end
		
		puts "no author count = #{no_author_count}"
		puts "short excerpt count = #{short_excerpt_count}"
		
		# puts article
		
	end
end