# frozen_string_literal: true

class Api::V1::TrendController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :set_trend, only: %i[index preload]

  # GET /trend?page
  def index
    render json: genPagination(
      @trend.preload(:bookmarks),
      [],
      @trend_num,
      @page,
      Constants::TREND_PER_PAGE
    )
  end

  # GET /trend/preload?page
  def preload
    render json: genPagination(
      @trend.preload(:comments, :bookmarks),
      { comments: :user },
      @trend_num,
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
    entry_count_about = ActiveRecord::Base.connection.execute("select reltuples from pg_class where relname='entries';")[0]["reltuples"]
    @trend_num = Constants::TREND_MAX_NUM < entry_count_about ? Constants::TREND_MAX_NUM : Entry.count
  end

  # Only allow a trusted parameter "white list" through.
  def trend_params
    params.permit(:page)
  end
end
