class ChangeColumnToBookmark < ActiveRecord::Migration[5.2]
  def change
    rename_column :bookmarks, :thread_id, :entry_id
  end
end
