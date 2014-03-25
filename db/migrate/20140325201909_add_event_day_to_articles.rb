class AddEventDayToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :event_day, :integer
  end
end
