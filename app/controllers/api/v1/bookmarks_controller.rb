class Api::V1::BookmarksController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :set_bookmark, only: [:show, :update, :destroy]
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

    if @entry.nil?
      @entry = Entry.create_or_get(@bookmark.original_url)
    end

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

    def create_by_entry_id_params
      params.require(:bookmark).permit(:comment)
    end
end
