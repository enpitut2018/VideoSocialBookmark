class Api::V1::TrendController < ApplicationController
  before_action :set_trend, only: [:index]

  # GET /trend
  def index
    render json: @trend
    #p @trend
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trend
      
      Entry.find_each do |entry|
        entry[:num_of_bookmarked] = entry.count_bookmarks
      end
      @trend=Entry.all.reorder!(num_of_bookmarked: :desc)
    end

    # Only allow a trusted parameter "white list" through.
    #def trend_params
    #  params.fetch(:entry, {}).permit(:page)
    #end
end
