# frozen_string_literal: true

class EntrySerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :video_id, :thumbnail_url, :provider, :num_of_bookmarked, :bookmarked?
  attribute :comments_page_count, if: -> { object.association(:comments).loaded? } do
    (object.comments.size.to_f / Constants::COMMENTS_PER_PAGE.to_f).ceil
  end
  has_many :comments do
    object.comments.order("created_at DESC").limit(Constants::COMMENTS_PER_PAGE).preload(:user)
  end

  def bookmarked?
    return nil unless scope.api_v1_user_signed_in?

    object.bookmarks.any? { |bookmark| bookmark.user_id == scope.current_api_v1_user.id }
  end
end
