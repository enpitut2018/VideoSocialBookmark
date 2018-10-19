class Api::V1::BookmarksController < ApplicationController
  before_action :set_bookmark, only: [:show, :update, :destroy]
  before_action :authenticate_api_v1_user!, only: [:create, :update, :destroy]

  # GET /bookmarks
  def index
    @bookmarks = Bookmark.all

    render json: @bookmarks
  end

  # GET /bookmarks/1
  def show
    render json: @bookmark
  end

  # POST /bookmarks
  def create
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.user_id = current_api_v1_user.id

    @entry = Entry.new(title: "title", url: @bookmark.original_url)
    @bookmark.entry_id = @entry.id

    if @entry.save
      if @bookmark.save
        render json: @bookmark, status: :created
      else
        render json: @bookmark.errors, status: :unprocessable_entity
      end
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bookmarks/1
  def update
    if @bookmark.update(bookmark_params)
      render json: @bookmark
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bookmarks/1
  def destroy
    @bookmark.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def bookmark_params
      params.require(:bookmark).permit(:comment, :star_count, :private, :original_url)
    end
end
