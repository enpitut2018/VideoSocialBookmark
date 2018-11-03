# frozen_string_literal: true

class Api::V1::BookmarksController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_api_v1_user!, only: :destroy
  before_action :set_bookmark, only: :destroy

  # DELETE /bookmarks/:id
  def destroy
    if @bookmark.nil? || @bookmark.user != current_api_v1_user
      render status: :bad_request
    else
      @bookmark.destroy
      render status: :ok
    end
  end

  private

  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end
end
