# frozen_string_literal: true

class Api::V1::PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :update, :add_item, :destroy]
  before_action :authenticate_api_v1_user!, only: [:create, :update, :add_item, :destroy]

  # GET /playlists/:id
  def show
    # TODO:
    render json: @playlist
  end

  # POST /playlists
  def create
    playlist = Playlist.new(playlist_params[:name, :is_private])
    render json: playlist.errors, status: :unprocessable_entity unless playlist.save
    render json: @playlist
  end

  # PUT /playlists/:id
  def update
    if @playlist.nil? ||
       @playlist.update(playlist_update_params)
      render status: :bad_request
    else
      render status: :ok
    end
  end

  # POST /playlists/:id
  def add_item
    # TODO: move to model
    playlist_item = PlaylistItem.create(playlist_item_params[:playlist_id, :entry_id, :prev_id, :next_id])
    id = playlist_item.id

    prev_id = playlist_item_params[:prev_id]
    next_id = playlist_item_params[:next_id]
    if prev_id != nil
      prev_item = Playlist.find(prev_id)
      render status: :bad_request if prev_item.nil?

      prev_item.update_attribute = { next_id: id }
    end
    if next_id != nil
      next_item = Playlist.find(next_id)
      render status: bad_request if next_item.nil?

      next_item.update_attribute = { prev_id: id }
    end

    render json: playlist_item
  end

  # DELETE /playlists/:id
  def destroy
    if @playlist.nil? || @playlist.user != current_api_v1_user
      render status: :bad_request
    else
      @playlist.destroy
      render status: :ok
    end
  end

  private

  def set_playlist
    # TODO: private playlist
    @playlist = Playlist.includes(:entry).find(params[:id])
  end

  def playlist_params
    params.require(:playlist).permit(:name, :is_private)
  end

  def playlist_update_params
    params.require(:playlist).permit(:name, :is_private)
  end

  def playlist_item_params
    params.require(:playlist_item).permit(:playlist_id, :entry_id, :prev_id, :next_id)
  end
end
