# frozen_string_literal: true

class Api::V1::TrendController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :set_trend, only: %i[index preload]

  # GET /trend?page
  def index
    render json: genPagination(
      @trend.preload(:bookmarks),
      [],
      Entry.count,
      @page,
      Constants::TREND_PER_PAGE
    )
  end

  # GET /trend/preload?page
  def preload
    render json: genPagination(
      @trend.preload(:comments, :bookmarks),
      { comments: :user },
      Entry.count,
      @page,
      Constants::TREND_PER_PAGE
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trend
    @page = trend_params[:page].present? ? trend_params[:page].to_i : 1
    @trend = Entry
             .order("num_of_bookmarked DESC")
             .page(@page)
             .per(Constants::TREND_PER_PAGE)
  end

  # Only allow a trusted parameter "white list" through.
  def trend_params
    params.permit(:page)
  end
end
