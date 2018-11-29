# frozen_string_literal: true

class PlaylistItem < ApplicationRecord
  belongs_to :playlist
  belongs_to :entry
end
