# frozen_string_literal: true

class DeleteTitleHashIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :entries, :title
  end
end
