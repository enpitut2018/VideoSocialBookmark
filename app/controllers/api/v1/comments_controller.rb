class Api::V1::CommentsController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_api_v1_user!, only: [:create, :update, :destroy]

  # GET /entries/:entry_id/comments
  def index
    @comments = Entry.find(params[:entry_id]).comments
    render json: @comments
  end

  # POST entries/:entry_id/comments
  def create
    @comment = Comment.new(comment_params)

    @bookmark = Bookmark.find_by(entry_id: params[:entry_id])
    if @bookmark.nil?
      @entry = Entry.find(:entry_id)
      if @entry.nil?
        redirect_to controller: 'api', action: 'routing_error'
      end

      @bookmark = Bookmark.new(entry_id: @entry.id, user_id: current_api_v1_user.id)
      unless @bookmark.save
        redirect_to controller: 'api', action: 'routing_error'
      end
    end
    @comment.bookmark_id = @bookmark.id

    if @comment.save
      render json: @bookmark, status: :created
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comment).permit(:content)
    end
end
