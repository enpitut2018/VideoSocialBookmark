# frozen_string_literal: true

class BookmarkSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :entry
  has_one :user
  has_many :comments
end
