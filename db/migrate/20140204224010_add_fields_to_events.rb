class AddFieldsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :editors_pick, :boolean
    add_column :events, :edit_hash, :string
  end
end
