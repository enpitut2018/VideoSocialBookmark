class BookmarkSerializer < ActiveModel::Serializer
  attributes :id, :comment
  belongs_to :entry
end