class AddArchiveImagesToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :archive_images, :text
  end
end
