class Person < ActiveRecord::Base
	has_secure_password
	has_many :authorships
	has_many :articles, :through => :authorships
	has_many :attributions
	has_many :mediafiles, :through => :attributions
	# validates_presence_of :password, :on => :create, :if => :is_editor?
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :firstname, 	:presence   => true,
                    		:length     => { :maximum => 254 }
  	validates :lastname, 	:presence   => true,
                    		:length     => { :maximum => 254 }

  	validates :email,	:presence   => true,
                    	:format     => { :with => email_regex },
                    	:uniqueness => { :case_sensitive => false },
                    	:length     => { :within => 4..254 }
  
	
	def is_editor?
		editor == true
	end
	
	def official_name
		if other_designation.blank?
			"#{firstname} #{lastname} / Beacon #{staff? ? "Staff" : "Correspondent" }"
		else
			"#{firstname} #{lastname} #{other_designation == "*" ? "" : "/ #{other_designation}"}"
		end
	end
	
	def full_name
		"#{firstname} #{lastname}"
	end
	
	def designation
		return "Editor" if editor?
		return "Staff" if staff?
		return other_designation if !other_designation.blank?
		return "Correspondent"
	end
	
	def contact_info
		ret = "#{lastname} can be reached at <a href='mailto:#{email}'>#{email}</a>."
		ret << " Follow them on Twitter at <a href='http://twitter.com/#{twitter}'>@#{twitter}</a>." unless twitter.blank?
		return ret
	end
	
end
