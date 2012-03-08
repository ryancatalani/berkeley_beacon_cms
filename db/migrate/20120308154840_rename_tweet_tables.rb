class RenameTweetTables < ActiveRecord::Migration
	def change
		rename_table 'ecla_all_tweets', 'ecla_any_tweet'
		rename_table 'ecla_beacon_tweets', 'ecla_beacon_tweet'
	end
end
