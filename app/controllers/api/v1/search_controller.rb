# frozen_string_literal: true

class Api::V1::SearchController < ApplicationController
  before_action :set_entry, only: %i[entry]

  # GET /search/entry?title=&page=
  def entry
    render json: genPagination(
      @result.preload(:bookmarks),
      [],
      @total,
      @page,
      Constants::SEARCH_PER_PAGE
    )
  end

  private

  def set_entry
    render notiong: true, status: :bad_request if search_params[:title].blank?
    @title = search_params[:title]
    @page = search_params[:page].present? ? search_params[:page].to_i : 1
    @search = Entry.where("title LIKE ?", "%#{params[:title]}%")
    @total = @search.length
    @result = @search.order("num_of_bookmarked DESC")
                     .page(@page)
                     .per(Constants::SEARCH_PER_PAGE)
  end

  def search_params
    params.permit(:page, :title)
  end
end
