# frozen_string_literal: true

class Api::V1::BookmarksController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_api_v1_user!, only: %i[create destroy]

  # POST /bookmarks
  def create
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.user_id = current_api_v1_user.id
    if @bookmark[:entry_id].nil?
      @entry = Entry.create_or_get(@bookmark.original_url)
      @bookmark.entry_id = @entry.id
    end
    if @bookmark.save
      render json: @bookmark, status: :created
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bookmarks
  def destroy
    @bookmark = Bookmark.find_by(entry_id: bookmark_params[:entry_id],
                                 user_id: current_api_v1_user.id)
    redirect_to controller: "api", action: "routing_error" if @bookmark.nil?
    @bookmark&.destroy
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:entry_id, :private, :original_url)
  end
end
