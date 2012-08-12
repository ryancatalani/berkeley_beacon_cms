namespace :db do
	desc "Import old articles from XML"
	task :xml_import_old_articles => :environment do
		
		Article.where(:archive => true).each{|a| a.delete}

		posts_xml = File.open(Rails.root.join("protected/wp_cka5ts_posts_view.xml"))
		relationships_xml = File.open(Rails.root.join("protected/wp_cka5ts_term_relationships_view.xml"))
		terms_xml = File.open(Rails.root.join("protected/wp_cka5ts_terms_view.xml"))

		posts = Nokogiri::XML(posts_xml)
		relationships = Nokogiri::XML(relationships_xml)
		terms = Nokogiri::XML(terms_xml)
		
		no_author_count = 0
		short_excerpt_count = 0

		posts.css("row").first(100).last(10).each_with_index do |row, index|
			puts ''
			puts index
			no_author = false
			short_excerpt = false
			student_of_the_week = false
			
			# ARTICLE VALUES
			title = ''
			cleantitle = ''
			content = ''
			author = ''
			correspondent = true
			staff = false
			other_designation = '' # Not really used, but I guess I could
			archive_images = []
			section_id = nil
			date = DateTime.new
			
			row.css("field").each do |field|
			
				case field['name']
				when 'ID'
					# article ID
					# maybe we can go through terms and term relationships here
					term_ids = []
					potential_section_names = []
					relationships.css("row").each do |r|
						if r.css('field[name="object_id"]').text == field.content.to_s
							term_ids << r.css('field[name="term_taxonomy_id"]').text
						end
					end
					term_ids.each do |term_id|
						terms.css("row").each do |r|
							if r.css('field[name="term_id"]').text == term_id
								potential_section_names << r.css('field[name="name"]').text
								break 
							end
						end
					end

					if potential_section_names.count == 0
						section_id = Section.find_by_name("News")
					elsif potential_section_names.count == 1
						name = potential_section_names.first
						if name.include?("News")
							section_id = Section.find_by_name("News").id
						elsif name.include?("Sports")
							section_id = Section.find_by_name("Sports").id
						elsif name.include?("Arts")
							section_id = Section.find_by_name("Arts").id
						elsif name.include?("Lifestyle")
							section_id = Section.find_by_name("Lifestyle").id
						elsif name.include?("Opinion")
							section_id = Section.find_by_name("Opinion").id
						else
							section_id = Section.find_by_name("News").id
						end
					else
						potential_section_names.each do |name|
							if name.include?("News")
								section_id = Section.find_by_name("News").id
								break
							elsif name.include?("Sports")
								section_id = Section.find_by_name("Sports").id
								break
							elsif name.include?("Arts")
								section_id = Section.find_by_name("Arts & Entertainment").id
								break
							elsif name.include?("Lifestyle")
								section_id = Section.find_by_name("Lifestyle").id
								break
							elsif name.include?("Opinion")
								section_id = Section.find_by_name("Opinion").id
								break
							end
						end
						section_id = Section.find_by_name("News").id
					end

				when 'post_title'
					# article title
					title = field.content.to_s
					cleantitle = title.strip.downcase.gsub(/[^A-z0-9\s]/,'').split(' ').first(8).join('-')
					puts "title: #{title}"
				when 'post_content'
					# article content
					# raw_body = field.content.gsub(/<\/?div.*?>/,'')
					raw_body = field.content
					
					# --- Determining author ---
					staff = raw_body.downcase.include?("beacon staff")

					raw_author, raw_content = raw_body.split('</strong>',2)
					raw_content, raw_author = raw_author, nil if raw_content.nil? or (!raw_author.nil? and raw_author.length > raw_content.length)
					
					# "No, the raw_content can't be blank," he thought.
					# "That would make no sense," he thought.
					# "I am wrong," he thought.
					# "Or maybe they are wrong," he thought.
					next if raw_content.blank?

					if !raw_author.nil? and raw_author.split(',',2).pop.split(' ').count < 4 and raw_author.split(',',2).pop.include?('Beacon')
						raw_author = raw_author.split('<strong>').pop if raw_author.include?('<strong>')
						raw_author = raw_author.strip.split("\n",2).pop if raw_author.include?("\n")
						raw_author = raw_author.gsub(/<.*?>/,'').strip
						# puts "is BB: #{raw_author}"
						author = raw_author.split(',',2).first.strip
					end
					
					
					if raw_author.nil? or raw_author.blank? or author.blank? or !raw_author.include?("Beacon")
						# Okay, so here it gets ugly.
						# Basically looking for any occurrence of Beacon (Staff|Correspondent), then
						# backstepping to find the name before that.

						b_occ = []
						raw_content_array = raw_content.split(' ')
						raw_content_array.each_with_index{|x,i| b_occ << i if x.downcase.include?("beacon") }
						b_occ.each do |index|
							if !raw_content_array[index+1].nil?
								if raw_content_array[index+1].downcase.include?("staff") or raw_content_array[index+1].downcase.include?("correspondent")
									n = raw_content_array[index-2..index].join(' ').split(',',2).first
									if !n.nil? and !n.index(/[^a-zA-Z\s]/).nil?
										author = n[n.rindex(/[^a-zA-Z\s]/)+1,n.length].strip
										break
									end
									author = n
								end
							end
						end
					end

					puts "author: #{author}"

					if !author.blank?
						raw_content = raw_content.split(author,2).last
					end

					# Time to find the image! Pray that there's only one image. Cause we're only going to find one for now.
					if raw_content.first(600).include?("/caption]")
						image_stuff, raw_content = raw_content.split("/caption]",2)
						caption = /caption="(.+?)"/.match(image_stuff)[1] rescue nil
						src = /href="(.+?)"/.match(image_stuff)[1] rescue nil
						archive_images = [{:caption => caption, :src => src}]
					end

					raw_content = raw_content.split(/\n+/).map { |para| "<p>" + para + "</p>" }.join('')

					content = raw_content

					p content
						
				when 'post_modified'
					date = DateTime.parse field.content.to_s
					puts "date: #{date}"
				else
					# puts "unexpected field: #{field['name']}"
				end
			
			end # Finished going through each field

			# Create or find the author
			author_id = nil
			if !author.blank? and author.include?(' ')
				firstname, lastname = author[0,author.rindex(' ')].strip.gsub(/[^a-zA-Z]/,'').capitalize, author[author.rindex(' '),author.length].strip.gsub(/[^a-zA-Z]/,'').capitalize
				candidates = Person.where(:lastname => lastname)
				if candidates.empty?
					# Create a new person
					x_arr = ('A'..'z').to_a + (0..9).to_a
					x_str = x_arr.sort_by{ rand }.first(25).join
					p = Person.create!(
						:firstname => firstname,
						:lastname => lastname,
						:email => "archives+#{firstname.first.downcase}#{lastname.downcase}@berkeleybeacon.com",
						:from_archive => true,
						:staff => staff,
						:password => x_str,
						:password_confirmation => x_str
						)
					author_id = p.id
				else
					# Last name exists, but there may be more than one person with that last name
					found_person = false
					candidates.each do |candidate|
						if candidate.firstname.downcase.include?(firstname.downcase) or firstname.downcase.include?(candidate.firstname.downcase)
							author_id = candidate.id
							found_person = true
						end
					end
					if !found_person
						potential_email = "archives+#{firstname.first.downcase}#{lastname.downcase}@berkeleybeacon.com"
						if Person.find_by_email(potential_email).nil?
							x_arr = ('A'..'z').to_a + (0..9).to_a
							x_str = x_arr.sort_by{ rand }.first(25).join
							p = Person.create!(
								:firstname => firstname,
								:lastname => lastname,
								:email => potential_email,
								:from_archive => true,
								:staff => staff,
								:password => x_str,
								:password_confirmation => x_str
								)
							author_id = p.id
						else
							author_id = Person.find_by_email(potential_email).id
						end
					end
				end
			else
				author_id = Person.find_by_firstname_and_lastname("Beacon","Staff").id
			end

			next if content.blank?

			# create the article.
			the_article = Article.create!(
			# the_article = Article.new(
				:title => title,
				:cleantitle => cleantitle,
				:body => content,
				:excerpt => content.truncate(50),
				:articletype => 1,
				:section_id => section_id,
				:archive => true,
				:archive_images => archive_images,
				:views => 0
				)

			the_article.update_attribute(:created_at, date)
			the_article.update_attribute(:updated_at, date)
			
			Authorship.create!(:article_id => the_article.id, :person_id => author_id)

			puts "Created the article! #{the_article.id}"

		end
			
		
	end
end

def combine_bools(array)
	# array only contains boolean elements
	true_count = 0
	array.each { |val| true_count += 1 if val }
	true_count == array.count
end