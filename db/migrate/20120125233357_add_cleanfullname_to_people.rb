class AddCleanfullnameToPeople < ActiveRecord::Migration
  def change
    add_column :people, :clean_full_name, :string
  end
end
