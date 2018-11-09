class PlaylistItem < ApplicationRecord
  belongs_to :playlist
  belongs_to :entry
  belongs_to :playlist_item
end
