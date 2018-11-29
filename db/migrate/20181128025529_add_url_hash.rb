# frozen_string_literal: true

class AddUrlHash < ActiveRecord::Migration[5.2]
  def up
    execute "CREATE INDEX url_hashidx ON entries USING hash (url);"
  end

  def down
    execute "DROP INDEX url_hashidx on entries;"
  end
end
