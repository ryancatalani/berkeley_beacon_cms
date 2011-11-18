class CreateArticlemediacontents < ActiveRecord::Migration
  def change
    create_table :articlemediacontents do |t|
      t.integer :article_id
      t.integer :mediafile_id

      t.timestamps
    end
  end
end
