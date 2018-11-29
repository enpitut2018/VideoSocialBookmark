# frozen_string_literal: true

class RestructAddIndexBySingleIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :bookmarks, %i[user_id entry_id]
    remove_index :comments, %i[user_id entry_id]

    add_index :bookmarks, :user_id
    add_index :bookmarks, :entry_id
    add_index :comments, %i[entry_id user_id]
    add_index :entries, :title, name: "title_hashidx", using: :hash
    add_index :playlist_items, :playlist_id
    add_index :playlist_items, :entry_id
    add_index :playlists, :user_id
  end
end
