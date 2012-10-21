class AddMoreMetaInfoToPoliticalPollEntries < ActiveRecord::Migration
  def change
    add_column :political_poll_entries, :already_completed, :boolean
  end
end
