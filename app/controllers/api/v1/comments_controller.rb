# frozen_string_literal: true

class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_api_v1_user!, only: %i[create update destroy]
  before_action :set_bookmark, only: %i[update destroy]

  # GET /entries/:entry_id/comments?page=
  def index
    page = params[:page].present? ? params[:page].to_i : 1
    comments = Entry.find(params[:entry_id]).comments.order("created_at DESC")
    comments_paginated = comments.page(page).per(Constants::COMMENTS_PER_PAGE)
    render json: genPagination(
      comments_paginated,
      [:user],
      comments.count,
      page,
      Constants::COMMENTS_PER_PAGE
    )
  end

  # POST entries/:entry_id/comments
  def create
    entry = Entry.find(params[:entry_id])
    redirect_to controller: "api", action: "routing_error" unless entry

    comment = entry.comments.new(content: comment_params[:content], user_id: current_api_v1_user.id)
    if comment.save
      render json: comment, include: %i[entry user], status: :created
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  # PUT /comments/:id
  def update
    if @comment.nil? ||
       @comment.user != current_api_v1_user ||
       @comment.update(comment_params)
      render status: :bad_request
    else
      render status: :ok
    end
  end

  # DELETE /comments/:id
  def destroy
    if @comment.nil? || @comment.user != current_api_v1_user
      render status: :bad_request
    else
      @comment.destroy
      render status: :ok
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_comment
    @comment = Comments.find(params[:id])
  end
end
