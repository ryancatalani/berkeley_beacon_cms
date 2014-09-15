class AddSectionSharesToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :section_shares, :text
  end
end
