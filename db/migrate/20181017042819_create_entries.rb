class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries do |t|
      t.text :title
      t.text :url


      t.timestamps
    end
  end
end
