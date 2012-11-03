class AddPostedToSocialPosts < ActiveRecord::Migration
  def change
    add_column :social_posts, :posted, :boolean
  end
end
