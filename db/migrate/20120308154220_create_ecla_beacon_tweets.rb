class CreateEclaBeaconTweets < ActiveRecord::Migration
  def change
    create_table :ecla_beacon_tweets do |t|
      t.string :tweet_id
      t.string :profile_image_url
      t.string :from_user
      t.string :text

      t.timestamps
    end
    add_index :ecla_beacon_tweets, :tweet_id
  end
end
