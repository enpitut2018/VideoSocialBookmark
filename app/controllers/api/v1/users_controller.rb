class Api::V1::UsersController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :authenticate_api_v1_user!

  # GET /user
  def index
    render json: current_api_v1_user
  end

  # GET /current_user/icon
  def index_user_icon
    render json: { "userIcon": { "url": current_api_v1_user.image } }
  end
end
