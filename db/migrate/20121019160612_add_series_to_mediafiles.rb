class AddSeriesToMediafiles < ActiveRecord::Migration
  def change
    add_column :mediafiles, :series_id, :integer
  end
end
