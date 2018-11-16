class ChangeColumnToUserNotNull < ActiveRecord::Migration[5.2]
  def up      
	  change_column :entry_stars, :user_id, :integer, null: false
          change_column :entry_stars, :entry_id, :integer, null: false
  end

  def down	        
	  change_column :entry_stars, :user_id,:integer
	  change_column :enry_stars, :entry_id,:integer
  end
end
