class BookmarkSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :entry
  has_one :user
end