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

	def url
		return ''
	end

	def self.to_approve
		where('approved IS ? AND date_start > ?', nil, Time.now).order(:date_start)
	end

	def self.upcoming_week
		where('approved = ? AND date_start >= ? AND date_start <= ?', true, Time.now, 1.week.from_now).order(:date_start)
	end

	def self.upcoming
		where('approved = ? AND date_start >= ?', true, 1.week.from_now).order(:date_start)
	end

	def organizer_email_is_emerson
		unless !organizer_email.blank? && organizer_email.include?("@emerson.edu")
			errors.add(:organizer_email, "must include @emerson.edu.")
		end
	end
end
