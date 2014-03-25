class AddEventPicksToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :event_picks, :text
  end
end
