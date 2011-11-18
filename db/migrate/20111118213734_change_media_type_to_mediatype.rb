class ChangeMediaTypeToMediatype < ActiveRecord::Migration
	def change
		rename_column :mediafiles, :type, :mediatype		
 	end

end
