# frozen_string_literal: true

class Bookmark < ApplicationRecord
  belongs_to :entry
  belongs_to :user

  after_save :update_entry_num_of_bookmarked
  after_destroy :update_entry_num_of_bookmarked

  validates :entry_id, uniqueness: { :scope => :user_id }

  private

  def update_entry_num_of_bookmarked
    entry.num_of_bookmarked = entry.bookmarks.size
    entry.save
  end
end
