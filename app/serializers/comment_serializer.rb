class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content
  belongs_to :bookmark
  belongs_to :user
end
