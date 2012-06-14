namespace :db do
	desc "Reset logins for 2012"
	task :reset_for_2012 => :environment do
		# Person.all.each do |person|
		# 	x_arr = ('A'..'z').to_a + (0..9).to_a
		# 	x_str = x_arr.sort_by{ rand }.first(100).join
		# 	person.update_attribute(:password, x_str)
		# 	email = person.email.downcase
		# 	person.update_attribute(:email, email)
		# end

		# editors = [
		# 	"Heidi Moeller",
		# 	"Hayden Wright",
		# 	"Ryan Catalani",
		# 	"Xakota Espinoza",
		# 	"Jackie Tempera",
		# 	"Frankie Olito",
		# 	"Stephanie Bradbury",
		# 	"Mike Disman",
		# 	"Eric Twardzik",
		# 	"Trelawney Davis",
		# 	"Alanna Grady",
		# 	"Sarah Black",
		# 	"Emily Murphy",
		# 	"Katy Rushlau",
		# 	"Christina Jedra",
		# 	"Sofya Levina",
		# 	"Jason Madanjian",
		# 	"Jaclyn Diaz",
		# 	"Sarah Verrill",
		# 	"Courtney Tharp",
		# 	"Ally Chapman",
		# 	"Jessica Nicholson",
		# 	"Mallory Meyer",
		# 	"Valerie Adamski",
		# 	"Christopher Eyer"
		# ]

		editors.each do |full_name|
			first, last = full_name.split(" ")
			person = Person.find_by_firstname_and_lastname(first, last)
			x_arr = ('A'..'z').to_a + (0..9).to_a
			x_str = x_arr.sort_by{ rand }.first(10).join
			new_pw = "emerson2012+#{x_str}"
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
			BeaconMailer.reset_password_2012(first, email, new_pw).deliver
			puts "Finished"
			puts ""
		end

	end
end