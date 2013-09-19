class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :pdf_url
      t.date :release_date

      t.timestamps
    end
  end
end
