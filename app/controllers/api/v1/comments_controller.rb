class Api::V1::CommentsController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :set_entry, only: %i[index create]
  before_action :authenticate_api_v1_user!, only: %i[create]

  # GET /entries/:entry_id/comments
  def index
    @comments = @entry.comments
    render json: @comments
  end

  # POST entries/:entry_id/comments
  def create
    @comments = @entry.comments.new(comment_params)
    @comments[:user_id] = current_api_v1_user.id
    if @comments.save
      render json: @bookmark, status: :created
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  private

  def set_entry
    @entry = Entry.find(params[:entry_id])
    redirect_to controller: 'api', action: 'routing_error' if @entry.nil?
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
