class CreateEclaAllTweets < ActiveRecord::Migration
  def change
    create_table :ecla_all_tweets do |t|
      t.string :tweet_id
      t.string :profile_image_url
      t.string :from_user
      t.string :text

      t.timestamps
    end
    add_index :ecla_all_tweets, :tweet_id
  end
end
