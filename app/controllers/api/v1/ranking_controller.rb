class Api::V1::RankingController < ApplicationController
  # GET /ranking/:page
  def index
    render json: Entry
      .page(ranking_params[:page])
      .includes(:bookmarks)
      .each{|t| t[:num_of_bookmarked] = t.bookmarks.size},
      include: '', # this line means not include bookmarks
      each_serializer: EntrySerializer
  end

  # GET /ranking/:page/preload
  def preload
    render json: Entry
      .page(ranking_params[:page])
      .includes(bookmarks: :user)
      .each{|t| t[:num_of_bookmarked] = t.bookmarks.size},
      include: 'bookmarks.user',
      each_serializer: EntrySerializer
  end

  private
    # Only allow a trusted parameter "white list" through.
    def ranking_params
      params.permit(:page)
    end
end
