class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :bookmarks, [:user_id, :entry_id]
    add_index :comments, :bookmark_id
    add_index :entry_stars, [:user_id, :entry_id]
  end
end
