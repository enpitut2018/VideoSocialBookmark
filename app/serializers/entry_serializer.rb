# frozen_string_literal: true

class EntrySerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :thumbnail_url, :num_of_bookmarked
  has_many :bookmarks
  has_many :comments, through: :bookmarks
  has_many :users, through: :bookmarks
end
