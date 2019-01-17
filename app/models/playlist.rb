# frozen_string_literal: true

class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_items, dependent: :destroy

  def deep_duplicate(user_id)
    kopy = Playlist.new
    kopy[:user_id] = user_id
    kopy[:name] = self[:name]
    kopy[:is_private] = false

    !kopy.save && return

    first_item = playlist_items.find do |item|
      item.prev_id.blank?
    end
    PlaylistItem.deep_duplicate(first_item, playlist_items, kopy[:id])
    kopy.playlist_items.find_by(entry_id: first_item[:entry_id]).change_prev_id nil

    kopy
  end
end
