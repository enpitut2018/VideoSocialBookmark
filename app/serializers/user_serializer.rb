class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :image, :entries
  has_many :entries, through: :bookmarks

  def entries
    object.
  end
end