class Api::V1::BookmarksController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_api_v1_user!, only: %i[create update destroy]

  # GET /bookmarks
  def index
    @bookmarks = Bookmark.all.where(private: false)
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

    @entry = Entry.create_or_get(@bookmark.original_url)
    @bookmark.entry_id = @entry.id

    if @bookmark.save
      render json: @bookmark, status: :created
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  # POST /entries/1
  def create_by_entry_id
    @entry = Entry.find(params[:entry_id])
    if @entry.nil?
      redirect_to controller: 'api', action: 'routing_error'
    else
      create
    end
  end

  private

  def set_bookmark
    someones_bookmark = Bookmark.find(params[:id])
    if someones_bookmark[:private]
      @bookmark = someones_bookmark if someones_bookmark[:user_id] == current_api_v1_user.user_id
    else
      @bookmark = someones_bookmark
    end
  end

  def bookmark_params
    params.require(:bookmark).permit(:star_count, :private, :original_url)
  end
end
