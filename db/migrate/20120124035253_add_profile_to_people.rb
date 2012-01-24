class AddProfileToPeople < ActiveRecord::Migration
  def change
    add_column :people, :profile, :string
  end
end
