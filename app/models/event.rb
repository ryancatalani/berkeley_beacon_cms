class Event < ActiveRecord::Base
	mount_uploader :image, EventImageUploader
	# validate :organizer_email_is_emerson
	# validates :organizer_email, :presence => true
	# validates :organizer_name, :presence => true
	validates :title, :presence => true
	validates :description, :presence => true
	validates :date_start, :presence => true
	validates :date_end, :presence => true
	validates :location, :presence => true
	before_save :create_slug_and_uid

	def url
		"/events/#{uid}/#{slug}"
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

	private

	def create_slug_and_uid
		if self.uid.nil?
			slug_base = title.blank? ? description.first(10) : title
			slug = slug_base.downcase.gsub(/[^a-zA-Z0-9 ]/,'').gsub(/[ ]/,'-').gsub(/-{2,}/,'-').first(30)
			last_id = Event.last.id+1 rescue 0
			uid = Time.now.to_i.to_s(36).split('').sample(5).join + "#{last_id}"
			if Event.find_by_uid(uid)
				uid = Time.now.to_i.to_s(36).split('').sample(5).join + "#{last_id}"
			end
			self.uid = uid
			self.slug = slug
		end
	end
end
