# frozen_string_literal: true

class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_items, dependent: :destroy
end
