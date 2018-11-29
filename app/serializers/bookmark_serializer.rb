# frozen_string_literal: true

class BookmarkSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :entry
  belongs_to :user
  has_one :users_comment

  def users_comment
    users_comments = object.entry.comments.select { |comment| comment.user_id == object.user_id }
    return users_comments[0] if users_comments.present?

    nil
  end
end
