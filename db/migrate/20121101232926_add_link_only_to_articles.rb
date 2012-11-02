class AddLinkOnlyToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :link_only, :boolean
  end
end
