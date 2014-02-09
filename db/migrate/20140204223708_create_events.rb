class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :organizer_name
      t.string :organizer_email
      t.datetime :date
      t.string :link
      t.boolean :approved

      t.timestamps
    end
  end
end
