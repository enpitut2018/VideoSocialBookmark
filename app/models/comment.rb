class Comment < ApplicationRecord
    belongs_to :bookmark
    delegate :user, to: :bookmark
end
