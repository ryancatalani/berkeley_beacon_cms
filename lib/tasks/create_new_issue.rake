namespace :db do
	desc "Create new issue"
	task :create_new_issue => :environment do
		# Based on http://stackoverflow.com/questions/7930370/ruby-code-to-get-the-date-of-next-monday-or-any-day-of-the-week
		t = Date.parse("Thursday")
		delta = t > Date.today ? 0 : 7
		next_thurs = t + delta

		unless Issue.find_by_release_date(next_thurs)
			Issue.create!(:release_date => next_thurs)
		end
	end
end