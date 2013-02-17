class RemoveUniquenessConstraintsFromShortLinks < ActiveRecord::Migration
  def up
  	remove_index :short_links, [:link_text, :prefix]
  end

  def down
  	add_index :short_links, [:link_text, :prefix], :unique => true
  end
end
