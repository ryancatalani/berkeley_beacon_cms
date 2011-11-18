class AddCleanTitleToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :cleantitle, :string
  end
end
