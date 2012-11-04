class CreateSocialPosts < ActiveRecord::Migration
  def change
    create_table :social_posts do |t|
      t.text :status_text
      t.integer :time
      t.integer :network

      t.timestamps
    end

    add_index :social_posts, :time
    add_index :social_posts, :network
  end
end
