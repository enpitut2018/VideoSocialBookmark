class BookmarkSerializer < ActiveModel::Serializer
  attributes :id, :comment
  belongs_to :entry
  has_one :user
end