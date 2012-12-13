class CreatePageviews < ActiveRecord::Migration
  def change
    create_table :pageviews do |t|
      t.integer :article_id
      t.string :encoded_ip_address

      t.timestamps
    end

    add_index :pageviews, :article_id
    add_index :pageviews, :encoded_ip_address
  end
end
