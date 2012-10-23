class AddConfirmationCodeToPoliticalPollEntries < ActiveRecord::Migration
  def change
    add_column :political_poll_entries, :confirmation, :string
  end
end
