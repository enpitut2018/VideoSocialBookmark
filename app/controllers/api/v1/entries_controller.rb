# frozen_string_literal: true

class Api::V1::EntriesController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :set_entry, only: [:show]
  before_action :authenticate_api_v1_user!, only: [:create]

  # GET /entries/:id
  def show
    id = api_v1_user_signed_in? ? current_api_v1_user.id : nil
    render json: @entry, include: [{ comments: :user }, { bookmarks: :user }, :users], user_id: id
  end

  # POST /entries
  def create
    entry = Entry.find_or_initialize_by_original_url(entry_params[:original_url])
    render json: entry.errors, status: :unprocessable_entity unless entry.save

    bookmark = entry.bookmarks.find_or_initialize_by(user_id: current_api_v1_user.id)
    render json: bookmark.errors, status: :unprocessable_entity unless bookmark.save

    comment = entry.comments.new(content: comment_params[:content], user_id: current_api_v1_user.id)
    if comment.save
      render json: comment, include: %i[entry user], status: :created
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  # PUT /entries/:id
  def update
    if @entry.nil? ||
       @entry.update(entry_update_params)
      render status: :bad_request
    else
      render status: :ok
    end
  end

  private

  def set_entry
    @entry = Entry.includes([comments: :user, bookmarks: :user]).find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:original_url)
  end

  def entry_update_params
    params.require(:entry).permit(:original_url, :title, :thumbnail_url)
  end

  def comment_params
    params.fetch(:comment, content: "").permit(:content)
  end
end
