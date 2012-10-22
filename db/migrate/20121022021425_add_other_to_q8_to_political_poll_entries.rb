class AddOtherToQ8ToPoliticalPollEntries < ActiveRecord::Migration
  def change
    add_column :political_poll_entries, :q8_other, :string
  end
end
