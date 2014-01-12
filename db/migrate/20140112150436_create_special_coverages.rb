class CreateSpecialCoverages < ActiveRecord::Migration
  def change
    create_table :special_coverages do |t|
      t.integer :lead
      t.text :featured
      t.integer :related_topic
      t.text :related_articles
      t.text :media
      t.text :updates

      t.timestamps
    end
  end
end
