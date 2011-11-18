class CreateMediafiles < ActiveRecord::Migration
  def change
    create_table :mediafiles do |t|
      t.string :title
      t.text :description
      t.integer :type
      t.string :media

      t.timestamps
    end
  end
end
