# frozen_string_literal: true

class AddVideoIdToEntry < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :video_id, :text
  end
end
