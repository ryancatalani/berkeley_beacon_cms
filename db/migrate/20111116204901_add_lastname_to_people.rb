class AddLastnameToPeople < ActiveRecord::Migration
  def change
    add_column :people, :lastname, :string
	rename_column :people, :name, :firstname
  end
end
