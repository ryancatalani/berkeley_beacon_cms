class CreateAuthorships < ActiveRecord::Migration
  def change
    create_table :authorships do |t|
      t.integer :person_id
      t.integer :article_id

      t.timestamps
    end
  end
end
