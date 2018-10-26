class Api::V1::EntriesController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_api_v1_user!, only: [:create]
  before_action :set_entry, only: [:create]

  # POST entries
  def create
    if @entry.nil?
      @entry = Entry.new(url: entry_params[:original_url])
      @entry[:num_of_bookmarked] = @entry.count_bookmarks

      unless @entry.save
        redirect_to controller: 'api', action: 'routing_error'
      end
    end

    @bookmark = Bookmark.find_by(entry_id: @entry.id, user_id: current_api_v1_user.id)
    if @bookmark.nil?
      @bookmark = Bookmark.new(entry_id: @entry.id, user_id: current_api_v1_user.id)
      unless @bookmark.save
        redirect_to controller: 'api', action: 'routing_error'
      end
    end

    @comment = Comment.new(content: entry_params[:comment], bookmark_id: @bookmark.id)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find_by(url: entry_params[:original_url])
      unless @entry.nil?
        @entry[:num_of_bookmarked] = @entry.count_bookmarks
      end
    end

    # Only allow a trusted parameter "white list" through.
    def entry_params
      params.fetch(:entry, {}).permit(:original_url, :comment)
    end
end
