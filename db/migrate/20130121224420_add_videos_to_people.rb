class AddVideosToPeople < ActiveRecord::Migration
  def change
    add_column :people, :profile_video_mp4_url, :string
    add_column :people, :profile_video_ogg_url, :string
    add_column :people, :profile_video_webm_url, :string
  end
end
