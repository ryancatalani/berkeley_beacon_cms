class AddEditorialCartoonIdToMediafiles < ActiveRecord::Migration
  def change
    add_column :mediafiles, :editorial_cartoon_id, :integer
  end
end
