# frozen_string_literal: true

class Api::V1::CommentsController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_api_v1_user!, only: :create

  # GET /entries/:entry_id/comments
  def index
    @comments = Entry.find(params[:entry_id]).comments.includes(:user)
    render json: @comments, include: %i[bookmark user]
  end

  # POST entries/:entry_id/comments
  def create
    entry = Entry.find(params[:entry_id])
    redirect_to controller: "api", action: "routing_error" unless entry

    bookmark = entry.bookmarks.find_or_initialize_by(user_id: current_api_v1_user.id)
    render json: bookmark.errors, status: :unprocessable_entity unless bookmark.save

    comment = entry.comments.new(content: comment_params[:content], user_id: current_api_v1_user.id)
    if comment.save
      render json: bookmark, include: [{ entry: :comments }, :user], status: :created
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit(:content)
  end
end
