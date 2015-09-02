class CreateAbouts < ActiveRecord::Migration
  def change
    create_table :abouts do |t|
      t.text :col1
      t.text :col2
      t.text :col3

      t.timestamps
    end
  end
end
