class AddHorizontalToMediafiles < ActiveRecord::Migration
  def change
    add_column :mediafiles, :horizontal, :boolean, :default => true, :null => false
  end
end
