class CreateEditorialCartoons < ActiveRecord::Migration
  def change
    create_table :editorial_cartoons do |t|
      t.string :slug
      t.integer :issue_id

      t.timestamps
    end
  end
end
