class CreateAttributions < ActiveRecord::Migration
  def change
    create_table :attributions do |t|
      t.integer :person_id
      t.integer :mediafile_id

      t.timestamps
    end
  end
end
