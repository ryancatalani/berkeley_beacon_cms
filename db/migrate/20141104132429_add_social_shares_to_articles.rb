class AddSocialSharesToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :social_shares, :text
  end
end
