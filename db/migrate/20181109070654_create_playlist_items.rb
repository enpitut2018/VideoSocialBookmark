class CreatePlaylistItems < ActiveRecord::Migration[5.2]
  def change
    create_table :playlist_items do |t|
      t.integer :playlist_id
      t.integer :entry_id
      t.integer :prev_id
      t.integer :next_id

      t.timestamps
    end
  end
end
