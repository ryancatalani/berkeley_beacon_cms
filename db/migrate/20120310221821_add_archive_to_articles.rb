class AddArchiveToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :archive, :boolean
  end
end
