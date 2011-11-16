class AddSubtitlesToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :subtitles, :text
  end
end
