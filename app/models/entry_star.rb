# frozen_string_literal: true

class EntryStar < ApplicationRecord
  belongs_to :user
  belongs_to :entry
end
