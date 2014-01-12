class AddTitleToSpecialCoverages < ActiveRecord::Migration
  def change
    add_column :special_coverages, :title, :string
  end
end
