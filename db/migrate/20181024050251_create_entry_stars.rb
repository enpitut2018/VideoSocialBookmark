class CreateEntryStars < ActiveRecord::Migration[5.2]
  def change
    create_table :entry_stars do |t|
 	
	    t.integer :user_id, null: false
	    t.integer :entry_id, null: false
      t.timestamps
    end
  end
end
