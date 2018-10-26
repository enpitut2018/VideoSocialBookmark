class Api::V1::TrendController < ApplicationController
  before_action :set_trend, only: [:index, :preload]

  # GET /trend/:page
  def index
    render json: @trend, include: ''
  end

  # GET /trend/:page/preload
  def preload
    render json: @trend, include: 'bookmarks.user'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trend
      @trend = Entry
        .page(trend_params[:page])
        .includes(bookmarks: :user)
        .each{|e| e[:num_of_bookmarked] = e.bookmarks.size}
        .sort_by(&:num_of_bookmarked)
        .reverse
    end

    # Only allow a trusted parameter "white list" through.
    def trend_params
      params.permit(:page)
    end
end