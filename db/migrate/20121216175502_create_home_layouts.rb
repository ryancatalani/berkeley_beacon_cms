class CreateHomeLayouts < ActiveRecord::Migration
  def change
    create_table :home_layouts do |t|
      t.integer :layout_type
      t.text :articles
      t.text :breaking_text
      t.integer :breaking_article
      t.text :custom_top_html

      t.timestamps
    end
  end
end
