namespace :db do
	desc "Find most popular recent articles"
	task :disable_archived_comments => :environment do

		Article.where(:archive => true).all.each do |article|
			article.update_attribute(:disable_comments, true)
		end

	end
end