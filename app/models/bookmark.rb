class Bookmark < ApplicationRecord
  belongs_to :entry
  belongs_to :user
end
