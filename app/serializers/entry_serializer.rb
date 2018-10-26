class EntrySerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :thumbnail_url, :num_of_bookmarked
  has_many :bookmarks
  has_many :comments, through: :bookmarks
  has_many :users, through: :bookmarks

  def num_of_bookmarked
    object.num_of_bookmarked.nil? ? object.count_bookmarks : object.num_of_bookmarked
  end
end
