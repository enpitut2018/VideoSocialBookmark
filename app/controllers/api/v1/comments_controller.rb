class Api::V1::CommentsController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :set_bookmark, only: %i[create]
  before_action :authenticate_api_v1_user!, only: %i[create update]

  # GET /entries/:entry_id/comments
  def index
    @comments = Entry.find(params[:entry_id]).comments
    render json: @comments
  end

  # POST entries/:entry_id/comments
  def create
    @comment = Comment.new(comment_params)
    @comment.bookmark_id = @bookmark.id

    if @comment.save
      render json: @bookmark, status: :created
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  private

  def set_bookmark
    unless Entry.exists?(id: params[:entry_id])
      redirect_to controller: 'api', action: 'routing_error'
    end

    @bookmark = Bookmark.find_or_create_by(entry_id: params[:entry_id],
                                           user_id: current_api_v1_user.id)
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
