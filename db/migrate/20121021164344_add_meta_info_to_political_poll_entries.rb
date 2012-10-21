class AddMetaInfoToPoliticalPollEntries < ActiveRecord::Migration
  def change
    add_column :political_poll_entries, :ip_digest, :string
    add_column :political_poll_entries, :start_time, :integer
    add_column :political_poll_entries, :end_time, :integer
  end
end
