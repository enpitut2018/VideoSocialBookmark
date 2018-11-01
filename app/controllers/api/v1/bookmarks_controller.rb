class Api::V1::BookmarksController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_api_v1_user!, only: [:create, :update, :destroy]

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

    if !Entry.exists?(id: @bookmark.entry_id)
      redirect_to controller: 'api', action: 'routing_error'
    end

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
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      someones_bookmark = Bookmark.find(params[:id])
      if someones_bookmark[:private]
        @bookmark = someones_bookmark if someones_bookmark[:user_id] == current_api_v1_user.user_id
      else
        @bookmark = someones_bookmark
      end
    end

    # Only allow a trusted parameter "white list" through.
    def bookmark_params
      params.require(:bookmark).permit(:private, :entry_id)
    end
end
