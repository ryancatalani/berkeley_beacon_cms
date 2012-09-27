class AddDirectUrlsToMediafiles < ActiveRecord::Migration
  def change
    add_column :mediafiles, :direct_mp4_url, :string
    add_column :mediafiles, :direct_ogg_url, :string
    add_column :mediafiles, :direct_webm_url, :string
  end
end
