namespace :db do
	desc "Recreate versions"
	task :recreate_versions => :environment do
		mc = Mediafile.count
		Mediafile.all.each_with_index do |mediafile, index|
			if mediafile.mediatype != 2
				puts "#{mediafile.id} (#{index+1}/#{mc})"
				begin
					mediafile.recreate_versions!
					puts "Successfully recreated versions"
				rescue Exception => e
					puts "Couldn't recreate versions"
					puts e
				end
			end
		end
	end
end