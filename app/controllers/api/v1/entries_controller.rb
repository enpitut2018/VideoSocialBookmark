# frozen_string_literal: true

class Api::V1::EntriesController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :set_entry, only: [:show]
  before_action :authenticate_api_v1_user!, only: [:create]

  # GET /entries/:id
  def show
    render json: @entry.includes(comment: :user), include: [comments: :user]
  end

  # POST entries
  def create
    @entry = Entry.create_or_get(entry_params[:original_url])
    @entry[:num_of_bookmarked] = @entry.safe_num_of_bookmarked

    @bookmark = Bookmark.find_by(entry_id: @entry.id, user_id: current_api_v1_user.id)
    if @bookmark.nil?
      @bookmark = Bookmark.new(entry_id: @entry.id, user_id: current_api_v1_user.id)
      redirect_to controller: "api", action: "routing_error" unless @bookmark.save
    end

    @comment = Comment.new(comment_params)
    @comment.bookmark_id = @bookmark.id

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.fetch(:entry, {}).permit(:original_url)
  end

  def comment_params
    params.fetch(:comment, {}).permit(:content)
  end
end
