class Person < ActiveRecord::Base
	has_secure_password
	# validates_presence_of :password, :on => :create, :if => :is_editor?
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :name, 	:presence   => true,
                    	:length     => { :maximum => 254 }
  	validates :email,	:presence   => true,
                    	:format     => { :with => email_regex },
                    	:uniqueness => { :case_sensitive => false },
                    	:length     => { :within => 4..254 }
  
	
	def is_editor?
		editor == true
	end
end
