class AddNumOfBookmarkedColumnToEntry < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :num_of_bookmarked, :integer
  end
end
