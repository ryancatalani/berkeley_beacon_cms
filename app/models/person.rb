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
		ret = "#{lastname} can be reached at <a href='mailto:#{email}'>#{email}</a>. "
		unless twitter.blank?
		  ret << "<br /><a href=\"https://twitter.com/#{twitter}\""
		  ret << ' class="twitter-follow-button" data-show-count="false" data-lang="en">Follow @magicofpi</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>'
	  end
    # ret << "Follow #{lastname} on Twitter at <a href='http://twitter.com/#{twitter}'>@#{twitter}</a>. " 
		return ret
	end
	
end
