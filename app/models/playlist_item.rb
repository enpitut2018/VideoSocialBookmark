# frozen_string_literal: true

class PlaylistItem < ApplicationRecord
  belongs_to :playlist
  belongs_to :entry

  def self.deep_duplicate(cur_item, items, playlist_id)
    PlaylistItem.exists?(playlist_id: playlist_id, entry_id: cur_item[:entry_id]) && (return new_cur_item)

    new_item = PlaylistItem.new(playlist_id: playlist_id, entry_id: cur_item[:entry_id])

    if cur_item[:next_id].present?
      next_item = items.find do |item|
        item[:id] == cur_item[:next_id]
      end
      next_item = PlaylistItem.deep_duplicate(next_item, items, playlist_id)
      new_item[:next_id] = next_item[:id]
    end

    new_item.save
    new_item
  end

  def change_prev_id(prev_id)
    self[:prev_id] = prev_id
    save

    self[:next_id].blank? && (return true)

    next_item = PlaylistItem.find(self[:next_id])
    next_item.change_prev_id(self[:id])
  end
end
