class Event < ActiveRecord::Base
	mount_uploader :image, EventImageUploader
	validate :organizer_email_is_emerson
	validates :organizer_email, :presence => true
	validates :organizer_name, :presence => true
	validates :title, :presence => true
	validates :description, :presence => true
	validates :date_start, :presence => true
	validates :date_end, :presence => true
	validates :location, :presence => true

	def organizer_email_is_emerson
		unless !organizer_email.blank? && organizer_email.include?("@emerson.edu")
			errors.add(:organizer_email, "must include @emerson.edu.")
		end
	end
end
