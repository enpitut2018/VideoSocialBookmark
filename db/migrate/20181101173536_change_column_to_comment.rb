class ChangeColumnToComment < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :bookmark_id, :integer
    add_column :comments, :user_id, :integer
    add_column :comments, :entry_id, :integer
  end
end
