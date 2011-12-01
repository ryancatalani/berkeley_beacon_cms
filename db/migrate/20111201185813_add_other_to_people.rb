class AddOtherToPeople < ActiveRecord::Migration
  def change
    add_column :people, :other_designation, :string
  end
end
