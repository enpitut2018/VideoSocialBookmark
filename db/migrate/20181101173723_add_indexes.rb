class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :bookmarks, %i[user_id entry_id]
    add_index :comments, %i[user_id entry_id]
    add_index :entries, :num_of_bookmarked
    add_index :entry_stars, %i[user_id entry_id]
  end
end
