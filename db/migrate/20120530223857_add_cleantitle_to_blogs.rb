class AddCleantitleToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :cleantitle, :string
  end
end
