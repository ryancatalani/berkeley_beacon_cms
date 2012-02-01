class CreateStylebookEntries < ActiveRecord::Migration
  def change
    create_table :stylebook_entries do |t|
      t.text :body
      t.text :notes

      t.timestamps
    end
  end
end
