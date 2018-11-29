# frozen_string_literal: true

class Api::V1::SearchController < ApplicationController
  # GET /search/entry?title=
  def entry
    if params.key?(:title)
      entry = Entry.where("title LIKE ?", "%#{params[:title]}%")
      entry.includes([comments: :user, bookmarks: :user]) if entry.present?
      render json: entry, include: [{ comments: :user }, { bookmarks: :user }, :users]
    else
      render json: { status: 501, message: "invalid parameter" }, status: :not_implemented
    end
  end
end
