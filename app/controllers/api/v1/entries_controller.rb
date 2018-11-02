# frozen_string_literal: true

class Api::V1::EntriesController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :set_entry, only: [:show]
  before_action :authenticate_api_v1_user!, only: [:create]

  # GET /entries/:id
  def show
    render json: @entry, include: [comments: :user]
  end

  # POST /entries
  def create
    entry = Entry.find_or_initialize_by_original_url(entry_params[:original_url])
    render json: entry.errors, status: :unprocessable_entity unless entry.save

    bookmark = entry.bookmarks.find_or_initialize_by(user_id: current_api_v1_user.id)
    render json: bookmark.errors, status: :unprocessable_entity unless bookmark.save

    comment = entry.comments.new(content: comment_params[:content], user_id: current_api_v1_user.id)
    if comment.save
      render json: comment, status: :created
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_entry
    @entry = Entry.includes(comments: :user).find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:original_url)
  end

  def comment_params
    params.fetch(:comment, content: "").permit(:content)
  end
end
