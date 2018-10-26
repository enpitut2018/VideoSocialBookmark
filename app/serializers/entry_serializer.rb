class EntrySerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :thumbnail_url, :num_of_bookmarked
  has_many :bookmarks
  def num_of_bookmarked
    object.bookmarks.size
  end
end
