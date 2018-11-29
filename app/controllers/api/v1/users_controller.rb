# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!, only: %i[current_user_show current_user_icon update]
  before_action :set_user, only: %i[show bookmarks playlists]

  # GET /current_user
  def current_user_show
    render json: current_api_v1_user, include: ""
  end

  # GET /current_user/icon
  def current_user_icon
    render json: { "url": rails_blob_path(current_api_v1_user.avatar) }
  end

  # GET /users/:id
  def show
    render json: @user, include: ""
  end

  # PUT /current_user
  def update
    user = User.find(current_api_v1_user.id)
    if user.avatar.attach(params[:avatar]) &&
       user.update(user_update_params)
      render json: user
    else
      render status: :bad_request
    end
  end

  # GET /users/:id/bookmarks?page=
  def bookmarks
    page = params[:page].present? ? params[:page].to_i : 1
    bookmarks = @user.bookmarks.includes(entry: :bookmarks)
    bookmarks_paginated = bookmarks.page(page).per(Constants::USERBOOKMARKS_PER_PAGE)
    render json: genPagination(
      bookmarks_paginated,
      [{ entry: :bookmarks }],
      bookmarks.count,
      page,
      Constants::USERBOOKMARKS_PER_PAGE
    )
  end

  # GET /users/:id/playlists
  def playlists
    render json: @user.playlists.includes(playlist_items: { entry: :bookmarks }), include: { playlist_items: { entry: :bookmarks } }
  end

  private

  def user_update_params
    params.permit(:name, :email, :password)
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end
end
