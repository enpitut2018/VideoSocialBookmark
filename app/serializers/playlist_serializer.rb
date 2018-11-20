# frozen_string_literal: true

class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :is_private, :name
  belongs_to :user
  has_many :playlist_items
end
