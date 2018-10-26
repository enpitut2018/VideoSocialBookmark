class Api::V1::TrendController < ApplicationController
  before_action :set_trend, only: [:index]

  # GET /trend/:page
  def index
    render json: @trend
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trend
      # Entry.find_each do |entry|
      #   entry[:num_of_bookmarked] = entry.count_bookmarks
      #   byebug
      # end
      @trend = Entry.update_num_of_bookmarked(
        Entry.limit(100)
             .reorder!(num_of_bookmarked: :desc)
             .page(params[:page])
      )
    end
end
