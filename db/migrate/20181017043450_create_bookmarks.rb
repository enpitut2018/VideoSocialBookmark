class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.integer :user_id
      t.integer :thread_id
      t.text :comment
      t.integer :star_count
      t.boolean :private
      t.string :original_url

      t.timestamps
    end
  end
end
