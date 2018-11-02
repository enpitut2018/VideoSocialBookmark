# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :image
  has_many :entries, through: :bookmarks
  has_many :comments, through: :bookmarks
end
