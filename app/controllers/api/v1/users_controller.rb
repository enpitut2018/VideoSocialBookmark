class Api::V1::UsersController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_api_v1_user!, only: [:create, :update, :destroy]

  # GET /users
  def index
    @users= User.all

    render json: @users
  end

  # GET /users/1
  def show
    required_user=User.find_by(id:params[:id])
    render json: required_user.bookmarks
  end

end