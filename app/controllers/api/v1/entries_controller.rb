class Api::V1::EntriesController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :set_entry, only: [:show]
  before_action :authenticate_api_v1_user!, only: [:create]

  # GET /entries/:id
  def show
    render json: @entry, include: [comments: :user]
  end

  # POST entries
  def create
    @entry = Entry.create_or_get(entry_params[:original_url])
    if @entry.nil?
      render json: @entry.errors, status: :unprocessable_entity
      return
    end

    @bookmark = Bookmark.find_or_create_by(entry_id: @entry.id,
                                           user_id: current_api_v1_user.id)
    if @bookmark.nil?
      render json: @bookmark.errors, status: :unprocessable_entity
      return
    end

    if comment_params[:content].nil?
      render json: @entry, status: :created
      return
    end

    @comment = @entry.comments.new(comment_params)
    @comment[:user_id] = current_api_v1_user.id

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
