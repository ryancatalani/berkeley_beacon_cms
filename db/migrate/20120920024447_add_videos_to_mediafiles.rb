class AddVideosToMediafiles < ActiveRecord::Migration
  def change
    add_column :mediafiles, :video_mp4, :string
    add_column :mediafiles, :video_ogg, :string
    add_column :mediafiles, :video_webm, :string
  end
end
