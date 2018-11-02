# frozen_string_literal: true

class Api::V1::SearchController < ApplicationController
  # GET /search/entry?[url=]
  def entry
    if params.key?(:url)
      entry = Entry.find_by(url: params[:url])
      render json: entry
    else
      render json: { status: 501, message: "invalid parameter" }, status: :not_implemented
    end
  end
end
