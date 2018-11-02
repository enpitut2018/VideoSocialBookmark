# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content
  belongs_to :entry
  belongs_to :user
end
