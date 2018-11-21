# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :image
  has_many :comments
  has_many :bookmarks
  has_many :entries, through: :bookmarks
  has_many :playlists
end
