# frozen_string_literal: true

class Api::V1::TrendController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :set_trend, only: %i[index preload]

  # GET /trend/:page
  def index
    render json: @trend.includes(bookmarks: :user), include: ""
  end

  # GET /trend/:page/preload
  def preload
    render json: @trend.includes([{ comments: :user }, { bookmarks: :user }, :users]), include: [{ comments: :user }, { bookmarks: :user }, :users]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trend
    @trend = Entry
             .order("num_of_bookmarked DESC")
             .page(trend_params[:page])
  end

  # Only allow a trusted parameter "white list" through.
  def trend_params
    params.permit(:page)
  end
end
