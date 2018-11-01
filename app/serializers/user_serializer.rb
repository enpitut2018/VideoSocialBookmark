class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :image
  has_many :comments
  has_many :entries, through: :bookmarks
end
