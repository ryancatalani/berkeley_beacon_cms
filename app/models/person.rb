class Person < ActiveRecord::Base
	has_secure_password
	has_many :authorships
	has_many :articles, :through => :authorships
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
end
