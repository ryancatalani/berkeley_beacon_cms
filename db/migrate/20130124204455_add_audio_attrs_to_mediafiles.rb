class AddAudioAttrsToMediafiles < ActiveRecord::Migration
  def change
    add_column :mediafiles, :direct_audio_mp3_url, :string
    add_column :mediafiles, :direct_audio_ogg_url, :string
  end
end
