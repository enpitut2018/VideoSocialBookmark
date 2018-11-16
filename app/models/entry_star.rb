# frozen_string_literal: true

class EntryStar < ApplicationRecord
  belongs_to :user
  belongs_to :entry
   
  validates :user_id, presence: true
  validates :entry_id, presence: true
end
