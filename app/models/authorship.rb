class Authorship < ActiveRecord::Base
	belongs_to :article
	belongs_to :person
end
