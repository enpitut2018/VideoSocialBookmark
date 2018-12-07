# frozen_string_literal: true

class PlaylistItemSerializer < ActiveModel::Serializer
  attributes :id, :playlist_id, :entry_id, :prev_id, :next_id
  belongs_to :playlist
  belongs_to :entry
end
