class AddPostTimeToSocialPosts < ActiveRecord::Migration
  def change
    add_column :social_posts, :post_time, :datetime
    remove_column :social_posts, :time
  end
end
