class AddArticleIdToSocialPosts < ActiveRecord::Migration
  def change
    add_column :social_posts, :article_id, :integer
  end
end
