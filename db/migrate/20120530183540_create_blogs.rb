class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.text :description
      t.string :title

      t.timestamps
    end
  end
end
