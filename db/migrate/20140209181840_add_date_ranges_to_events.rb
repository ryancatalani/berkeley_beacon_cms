class AddDateRangesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :date_start, :datetime
    add_column :events, :date_end, :datetime
    remove_column :events, :date
  end
end
