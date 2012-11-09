class AddQueueAttrToSocialPosts < ActiveRecord::Migration
  def change
    add_column :social_posts, :in_queue, :boolean
  end
end
