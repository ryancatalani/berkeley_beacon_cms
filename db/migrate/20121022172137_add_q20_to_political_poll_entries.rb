class AddQ20ToPoliticalPollEntries < ActiveRecord::Migration
  def change
    add_column :political_poll_entries, :q20, :integer
  end
end
