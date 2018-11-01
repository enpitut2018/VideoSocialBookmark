class Api::V1::TrendController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :set_trend, only: [:index, :preload]

  # GET /trend/:page
  def index
    id = api_v1_user_signed_in? ? current_api_v1_user.id : nil
    render json: @trend, include: '', user_id: id
  end

  # GET /trend/:page/preload
  def preload
    id = api_v1_user_signed_in? ? current_api_v1_user.id : nil
    render json: @trend, include: 'bookmarks.user', user_id: id
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trend
      @trend = Entry
        .page(trend_params[:page])
        .includes(bookmarks: :user)
        .sort_by{ |entry| entry.bookmarks.size}
        .reverse
    end

    # Only allow a trusted parameter "white list" through.
    def trend_params
      params.permit(:page)
    end
end
