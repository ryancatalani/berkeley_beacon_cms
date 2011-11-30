class Attribution < ActiveRecord::Base
	belongs_to :person
	belongs_to :mediafile
end
