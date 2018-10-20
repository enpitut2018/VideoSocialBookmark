class Api::V1::RankingController < ApplicationController
  before_action :set_ranking, only: [:index]

  # GET /ranking
  def index
    render json: @ranking
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ranking
      @ranking = Entry.page(ranking_params[:page])
      @ranking.each do |entry|
        entry[:num_of_bookmarked] = entry.count_bookmarks
      end
    end

    # Only allow a trusted parameter "white list" through.
    def ranking_params
      params.fetch(:entry, {}).permit(:page)
    end
end
