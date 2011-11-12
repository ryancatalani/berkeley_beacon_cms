class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.text :excerpt
      t.integer :type
      t.integer :views

      t.timestamps
    end
  end
end
