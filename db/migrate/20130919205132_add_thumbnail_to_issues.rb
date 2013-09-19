class AddThumbnailToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :pdf_thumb_url, :string
  end
end
