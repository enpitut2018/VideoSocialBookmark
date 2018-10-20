class AddColumnToEntry < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :thumbnail_url, :text
  end
end
