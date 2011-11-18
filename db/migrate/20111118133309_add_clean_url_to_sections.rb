class AddCleanUrlToSections < ActiveRecord::Migration
  def change
    add_column :sections, :clean_url, :string
  end
end
