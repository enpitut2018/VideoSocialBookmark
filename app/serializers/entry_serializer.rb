# frozen_string_literal: true

class EntrySerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :thumbnail_url, :num_of_bookmarked, :bookmarked?
  has_many :bookmarks
  has_many :comments
  has_many :users, through: :bookmarks

  def bookmarked?
    @instance_options[:user_id].present? &&
      object.bookmarks.find_by(user_id: @instance_options[:user_id]).present?
  end
end
