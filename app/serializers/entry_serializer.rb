# frozen_string_literal: true

class EntrySerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :video_id, :thumbnail_url, :provider, :num_of_bookmarked, :bookmarked?
  has_many :bookmarks
  has_many :comments
  has_many :users, through: :bookmarks

  def bookmarked?
    return nil unless scope.api_v1_user_signed_in?

    object.bookmarks.any? { |bookmark| bookmark.user_id == scope.current_api_v1_user.id }
  end
end
