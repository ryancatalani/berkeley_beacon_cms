class ChangeArticlesTypeColumnToArticletype < ActiveRecord::Migration
	def change
		rename_column :articles, :type, :articletype
	end
end
