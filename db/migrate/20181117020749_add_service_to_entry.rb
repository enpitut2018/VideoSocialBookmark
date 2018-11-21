# frozen_string_literal: true

class AddServiceToEntry < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :provider, :text
  end
end
