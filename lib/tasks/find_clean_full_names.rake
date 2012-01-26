namespace :db do
	desc "Generate clean full names"
	task :generate_clean_full_names => :environment do
		Person.all.each do |person|
			fullname = person.firstname.downcase.gsub(/[^a-zA-Z]/,'-') + '-' + person.lastname.downcase.gsub(/[^a-zA-Z]/,'-')
			fullname.gsub!(/-{2,}/,'-')
			person.update_attribute(:clean_full_name,fullname)
		end
	end
end