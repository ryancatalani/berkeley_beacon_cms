class AddFromArchiveToPeople < ActiveRecord::Migration
  def change
    add_column :people, :from_archive, :boolean
  end
end
