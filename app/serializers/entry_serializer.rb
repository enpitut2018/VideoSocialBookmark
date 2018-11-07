# frozen_string_literal: true

class EntrySerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :thumbnail_url, :num_of_bookmarked, :bookmarked?
  has_many :bookmarks
  has_many :comments
  has_many :users, through: :bookmarks

  def bookmarked?
    return nil if @instance_options[:user_id].blank?

    object.bookmarks.any? { |bookmark| bookmark.user_id == @instance_options[:user_id] }
  end
end
