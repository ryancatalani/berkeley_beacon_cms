namespace :db do
	desc "Fill database with sample data"
	task :populate => :environment do
		
		# puts "Creating people"
		# 15.times do |n|
		# 	firstname = Faker::Name.first_name
		# 	lastname = Faker::Name.last_name
		# 	email = Faker::Internet.email
		# 	password = "foobar"
		# 	twitter = Faker::Internet.user_name
		# 	editor = false
		# 	staff = n % 3 == 0
		# 	Person.create!(:firstname => firstname,
		# 					:lastname => lastname,
		# 					:email => email,
		# 					:password => password,
		# 					:password_confirmation => password,
		# 					:twitter => twitter,
		# 					:editor => editor,
		# 					:staff => staff)
		# end
		
		# puts "Creating sections"
		# Section.all.each { |s| s.delete }
		# ["News","Sports","Lifestyle","Opinion"].each do |s|
		# 	Section.create!(:name => s, :clean_url => s.downcase)
		# end
		# Section.create!(:name => "Arts & Entertainment", :clean_url => "arts-and-entertainment")
		
		# puts "Deleting old articles and authorships"
		# Article.all.each {|a| a.delete}
		# Authorship.all.each {|auth| auth.delete}
		# 
		# puts "Creating articles"
		# Section.all.each do |section|
		# 	20.times do |n|
		# 		title = Faker::Lorem.words(10).join(' ')
		# 		excerpt = Faker::Lorem.paragraphs(1)
		# 		body = excerpt + Faker::Lorem.paragraphs(9)
		# 		articletype = rand(3) + 1
		# 		subtitles = [Faker::Lorem.words(8)]
		# 		cleantitle = title.strip.downcase.gsub(/[^A-z0-9\s]/,'').split(' ').first(8).join('-')
		# 		a = section.articles.create!(:title => title,
		# 									:excerpt => excerpt,
		# 									:body => body,
		# 									:articletype => articletype,
		# 									:subtitles => subtitles,
		# 									:cleantitle => cleantitle)
		# 		a.update_attribute(:views, 0)
		# 		author = Person.all[rand(Person.count)]
		# 		Authorship.create!(:article_id => a.id, :person_id => author.id)
		# 		if n % 4 == 0
		# 			author2 = Person.all[rand(Person.count)]
		# 			Authorship.create!(:article_id => a.id, :person_id => author2.id)
		# 		end
		# 	end
		# end
		
		puts "Creating tags and taggings"
		["Main Story", "Featured Story", "Middle Strip Story"].each do |t|
			Tag.create!(:name => t)
		end
		Article.all.sort_by { rand }.first(25).each_with_index do |a, i|
			if i <= 5
				Tagging.create!(:article_id => a.id, :tag_id => Tag.find_by_name("Main Story").id)
			elsif i > 5 and i <= 15
				Tagging.create!(:article_id => a.id, :tag_id => Tag.find_by_name("Featured Story").id)
			else
				Tagging.create!(:article_id => a.id, :tag_id => Tag.find_by_name("Middle Strip Story").id)				
			end
		end
		
	end # task
end # namespace