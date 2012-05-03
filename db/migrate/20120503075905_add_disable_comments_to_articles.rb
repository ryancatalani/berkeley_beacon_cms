class AddDisableCommentsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :disable_comments, :boolean
  end
end
