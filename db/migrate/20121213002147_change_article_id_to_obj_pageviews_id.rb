class ChangeArticleIdToObjPageviewsId < ActiveRecord::Migration
  def up
  	remove_index :pageviews, :article_id
  	rename_column :pageviews, :article_id, :obj_pageviews_id
  	add_index :pageviews, :obj_pageviews_id
  	add_column :pageviews, :obj_pageviews_type, :string
  end

  def down
  	remove_index :pageviews, :obj_pageviews_id
  	rename_column :pageviews, :obj_pageviews_id, :article_id
  	add_index :pageviews, :article_id
  	remove_column :pageviews, :obj_pageviews_type
  end
end
