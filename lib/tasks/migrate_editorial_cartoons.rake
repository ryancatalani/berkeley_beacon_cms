namespace :db do
	desc "Migrate editorial cartoons to model"
	task :migrate_editorial_cartoons => :environment do

		EditorialCartoon.destroy_all

		s = Series.find_by_title("Editorial Cartoons")
		existing_cartoon_mediafiles = s.mediafiles

		existing_cartoon_mediafiles.each do |cartoon_mediafile|
			puts "migrating mediafile id #{cartoon_mediafile.id}"
			cartoon_date = cartoon_mediafile.created_at
			if cartoon_date.wday == 4 # thursday
				issue_date = cartoon_date.to_date
			elsif cartoon_date.wday < 4
				# if before thursday, then it's probably from the previous week
				delta = cartoon_date.wday + 3
				issue_date = cartoon_date.to_date - delta.days
			else
				# if after thursday, then it's probably from the same week
				delta = cartoon_date.wday - 4
				issue_date = cartoon_date.to_date - delta.days
			end

			issue_id = Issue.find_by_release_date(issue_date)
			# this may be nil if no issue was created for that day

			slug = issue_date.strftime("%Y-%m-%d") + "-#{cartoon_mediafile.id}"

			editorial_cartoon = EditorialCartoon.create!(
				issue_date: issue_date,
				issue_id: issue_id,
				slug: slug
			)
			puts "created editorial cartoon id #{editorial_cartoon.id}"

			cartoon_mediafile.update_attribute(:editorial_cartoon_id, editorial_cartoon.id)
			puts "updated mediafile"

		end
		puts "done"

	end
end