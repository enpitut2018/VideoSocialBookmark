class EntrySerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :thumbnail_url, :num_of_bookmarked, :bookmarked?
  has_many :bookmarks
  has_many :comments
  has_many :users, through: :bookmarks

  def num_of_bookmarked
    object.num_of_bookmarked.nil? ? object.count_bookmarks : object.num_of_bookmarked
  end

  def bookmarked?
    return @instance_options[:user_id].present? &&
            object.bookmarks.find_by(user_id: @instance_options[:user_id]).present?
  end
end
