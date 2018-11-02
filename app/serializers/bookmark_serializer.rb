# frozen_string_literal: true

class BookmarkSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :entry
  belongs_to :user
end
