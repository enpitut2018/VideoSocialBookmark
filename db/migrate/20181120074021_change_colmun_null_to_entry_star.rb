class ChangeColmunNullToEntryStar < ActiveRecord::Migration[5.2]
  def change
	  change_column_null :entry_stars, :user_id, true
	  change_column_null :entry_stars, :entry_id, true
  end
end
