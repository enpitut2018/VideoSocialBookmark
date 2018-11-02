# frozen_string_literal: true

class Api::V1::UsersController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_api_v1_user!, only: [:show]

  # GET /user
  def index
    render json: current_api_v1_user
  end

  # GET /current_user/icon
  def index_user_icon
    render json: { "userIcon": { "url": current_api_v1_user.image } }
  end

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
