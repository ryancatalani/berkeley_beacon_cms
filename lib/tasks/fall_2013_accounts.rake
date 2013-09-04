namespace :db do
	desc "Create new fall 2013 accounts"
	task :fall_2013_accounts => :environment do
		# Person.all.each do |person|
		# 	x_arr = ('A'..'z').to_a + (0..9).to_a
		# 	x_str = x_arr.sort_by{ rand }.first(100).join
		# 	person.update_attribute(:password, x_str)
		# 	email = person.email.downcase
		# 	person.update_attribute(:email, email)
		# end

		new_editors = [
			"Liana Genito",
			"Kyle Brasseur",
			"Thea Byrd",
			"Dillon Riley",
			"Kelsey Drain"
		]

		new_editors.each do |full_name|
			first, last = full_name.split(" ")
			person = Person.find_by_firstname_and_lastname(first, last)
			new_pw = "emerson2013"
			email = nil
			puts "Working on #{full_name}..."
			if person
				person.update_attribute(:editor, true)
				person.update_attribute(:password, new_pw)
				email = person.email
			else
				fullname = first.downcase.gsub(/[^a-zA-Z]/,'-') + '-' + last.downcase.gsub(/[^a-zA-Z]/,'-')
				clean_full_name = fullname.gsub(/-{2,}/,'-')
				p = Person.create!(
					:firstname => first,
					:lastname => last,
					:email => "#{first}_#{last}@emerson.edu".downcase,
					:editor => true,
					:staff => true,
					:clean_full_name => clean_full_name,
					:password => new_pw,
					:password_confirmation => new_pw
					)
				email = p.email
			end
			BeaconMailer.new_account(first, email, new_pw).deliver
			puts "Finished"
			puts ""
		end

	end
end