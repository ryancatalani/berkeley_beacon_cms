class AddUidToEvents < ActiveRecord::Migration
  def change
    add_column :events, :uid, :string
    add_index :events, :uid
  end
end
