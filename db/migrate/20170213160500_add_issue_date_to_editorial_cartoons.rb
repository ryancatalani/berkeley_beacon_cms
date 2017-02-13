class AddIssueDateToEditorialCartoons < ActiveRecord::Migration
  def change
    add_column :editorial_cartoons, :issue_date, :date
  end
end
