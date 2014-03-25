class CreateArticleEventBinders < ActiveRecord::Migration
  def change
    create_table :article_event_binders do |t|
      t.integer :article_id
      t.integer :event_id

      t.timestamps
    end
  end
end
