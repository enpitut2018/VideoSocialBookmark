class ChangeCommentColumnToBookmark < ActiveRecord::Migration[5.2]
  def change
    remove_column :bookmarks, :comment, :text
  end
end
