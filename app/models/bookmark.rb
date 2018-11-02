# frozen_string_literal: true

class Bookmark < ApplicationRecord
  belongs_to :entry
  belongs_to :user
  has_many :comments, dependent: :destroy
end
