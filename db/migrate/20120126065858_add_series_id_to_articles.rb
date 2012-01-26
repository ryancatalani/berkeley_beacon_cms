class AddSeriesIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :series_id, :integer
  end
end
