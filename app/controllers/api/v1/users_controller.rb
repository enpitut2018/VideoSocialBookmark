# frozen_string_literal: true

class Api::V1::UsersController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_api_v1_user!, only: %i[current_user_show current_user_icon]
  before_action :set_user, only: %i[show bookmarks]

  # GET /current_user
  def current_user_show
    render json: current_api_v1_user, include: ""
  end

  # GET /current_user/icon
  def current_user_icon
    render json: { "userIcon": { "url": current_api_v1_user.image } } #  TODO : Implement user icon
  end

  # GET /users/:id
  def show
    render json: @user, include: ""
  end

  # GET /users/:id/bookmarks
  def bookmarks
    render json: @user.bookmarks.includes(:entry), include: :entry
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end
end
