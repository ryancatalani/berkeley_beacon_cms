class CreatePoliticalPollEntries < ActiveRecord::Migration
  def change
    create_table :political_poll_entries do |t|
    	(1..19).each do |num|
    		t.integer "q#{num}".to_sym
    	end
    	
      t.timestamps
    end
  end
end
