class AddEmailHashToPoliticalPollEntries < ActiveRecord::Migration
  def change
    add_column :political_poll_entries, :email_hash, :string
  end
end
