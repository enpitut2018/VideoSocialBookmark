class Api::V1::TrendController < ApplicationController
  before_action :set_trend, only: %i[index preload]

  # GET /trend/:page
  def index
    render json: @trend, include: ''
  end

  # GET /trend/:page/preload
  def preload
    render json: @trend, include: 'bookmarks.user'
  end

  private

  def set_trend
    @trend = Entry
      .page(trend_params[:page])
      .includes(bookmarks: :user)
      .sort_by{ |entry| entry.bookmarks.size}
      .reverse
  end

  def trend_params
    params.permit(:page)
  end
end
