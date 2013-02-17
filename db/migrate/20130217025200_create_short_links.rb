class CreateShortLinks < ActiveRecord::Migration
  def change
    create_table :short_links do |t|
      t.string :prefix
      t.string :link_text
      t.string :destination

      t.timestamps
    end

    add_index :short_links, :link_text
    add_index :short_links, [:link_text, :prefix], :unique => true
  end
end
