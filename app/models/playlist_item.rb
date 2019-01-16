# frozen_string_literal: true

class PlaylistItem < ApplicationRecord
  belongs_to :playlist
  belongs_to :entry
  has_many :playlist_items, dependent: :destroy

  amoeba do
    enable
    include_association :playlist_items
  end
end
