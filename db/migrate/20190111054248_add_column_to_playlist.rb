class AddColumnToPlaylist < ActiveRecord::Migration[5.2]
  def change
    add_column :playlists, :num_of_saved, :integer
  end
end
