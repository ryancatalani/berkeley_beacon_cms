namespace :articles do
	desc "Export word corpus from certain semester or dates"
	task :export_word_corpus => :environment do
		include ActionView::Helpers::SanitizeHelper

		# semester must be 'spring' or 'fall'
		semester = ENV['semester'].blank? ? (Time.zone.now.month > 5 ? 'spring' : 'fall') : ENV['semester']
		# year must be 4 digits
		year = ENV['year'].blank? ? Time.zone.now.year : ENV['year']

		if semester == 'spring'
			date_start 	= Date.parse("#{year}-01-01").midnight
			date_end 	= Date.parse("#{year}-05-31").midnight
		else
			date_start	= Date.parse("#{year}-06-01").midnight
			date_end	= Date.parse("#{year}-12-31").midnight
		end

		raw_text = Article.where(draft: false, created_at: date_start..date_end).map(&:body).join(' ')
		sanitized_text = strip_tags(raw_text)
		coder = HTMLEntities.new
		just_text = coder.decode(sanitized_text)

		words = just_text.split(%r{\s}).map{ |w| w.gsub(/([,.;:?!—–"“”]|'s|’s)/,'').strip }.delete_if { |w| w.blank? }

		proper_nouns = words.delete_if {|w| w.match(/\A[a-z]/)}
		

	end
end