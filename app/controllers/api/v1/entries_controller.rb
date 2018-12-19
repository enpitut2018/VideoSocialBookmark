# frozen_string_literal: true

class Api::V1::EntriesController < ApplicationController
  before_action :set_entry, only: %i[show update]
  before_action :authenticate_api_v1_user!, only: [:create]

  # GET /entries/find?[url]
  def find
    render status: :bad_request if params[:url].blank?
    entry = Entry.find_entry_by_original_url(params[:url])
    if entry.nil?
      render json: {}
    else
      render json: entry
    end
  end

  # GET /entries/:id
  def show
    render json: @entry, include: [{ comments: :user }, { bookmarks: :user }, :users]
  end

  # POST /entries
  def create
    entry = Entry.find_or_initialize_by_original_url(entry_params[:original_url])
    render json: entry.errors, status: :unprocessable_entity && return unless entry.save

    bookmark = entry.bookmarks.find_or_initialize_by(user_id: current_api_v1_user.id)
    render json: bookmark.errors, status: :unprocessable_entity && return unless bookmark.save

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
    @entry = Entry.includes(:comments, :bookmarks).find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:original_url)
  end

  def entry_update_params
    params.require(:entry).permit(:title)
  end

  def comment_params
    params.fetch(:comment, content: "").permit(:content)
  end
end
