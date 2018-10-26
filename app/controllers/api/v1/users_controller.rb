class Api::V1::UsersController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_api_v1_user!, only: [:create, :update, :destroy]

  # GET /users/:id
  def show
    user = User.find_by(id: params[:id])
    render json: user
  end

  # GET /users/:id/bookmarks
  def bookmarks
    user = User.find_by(id: params[:id])
    render json: user.bookmarks, include: :entry
  end

end