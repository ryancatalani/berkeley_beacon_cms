class AddConfirmedToPoliticalPollEntries < ActiveRecord::Migration
  def change
    add_column :political_poll_entries, :confirmed, :boolean
  end
end
