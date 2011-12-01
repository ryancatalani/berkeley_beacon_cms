class AddSourceToMediafiles < ActiveRecord::Migration
  def change
    add_column :mediafiles, :source, :string
  end
end
