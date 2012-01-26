class AddTitleToSeries < ActiveRecord::Migration
  def change
    add_column :series, :title, :string
  end
end
