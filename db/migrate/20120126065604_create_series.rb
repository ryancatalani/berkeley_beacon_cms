class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.text :description
      t.string :logo

      t.timestamps
    end
  end
end
