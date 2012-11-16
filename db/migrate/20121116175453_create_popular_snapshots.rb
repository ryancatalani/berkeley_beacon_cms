class CreatePopularSnapshots < ActiveRecord::Migration
  def change
    create_table :popular_snapshots do |t|
      t.text :most_viewed
      t.text :most_shared

      t.timestamps
    end
  end
end
