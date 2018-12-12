# frozen_string_literal: true

class Api::V1::PlaylistsController < ApplicationController
  before_action :set_playlist, only: %i[show update add_item]
  before_action :authenticate_api_v1_user!, only: %i[index create update add_item destroy_item]

  # GET /playlists
  def index
    playlists = Playlist.where(user_id: current_api_v1_user.id).includes(playlist_items: { entry: :bookmarks })
    render json: playlists, include: { playlist_items: :entry }
  end

  # GET /playlists/:id
  def show
    render json: @playlist, include: { playlist_items: { entry: :bookmarks } }
  end

  # POST /playlists
  def create
    playlist = Playlist.new(playlist_params)
    playlist[:user_id] = current_api_v1_user.id
    name = playlist[:name]
    i = 0
    while Playlist.exists?(name: name)
      name = playlist[:name] + i.to_s
      i += 1
    end
    playlist[:name] = name
    if playlist.save
      render json: @playlist
    else
      render json: playlist.errors, status: :unprocessable_entity unless playlist.save
    end
  end

  # PUT /playlists/:id
  def update
    if @playlist.blank?
      render status: :bad_request
    elsif @playlist.update(playlist_update_params)
      render json: @playlist
    else
      render status: :bad_request
    end
  end

  # POST /playlists/:id
  def add_item
    playlist_item = PlaylistItem.find_by(entry_id: playlist_item_params[:entry_id], playlist_id: params[:id])
    if playlist_item.present?
      render json: playlist_item
      return
    end

    playlist_item = PlaylistItem.new(playlist_item_params)
    playlist_item[:playlist_id] = params[:id]
    unless playlist_item.save
      render status: bad_request
      return
    end

    id = playlist_item.id

    prev_id = playlist_item_params[:prev_id]
    next_id = playlist_item_params[:next_id]
    if prev_id.present?
      prev_item = PlaylistItem.find(prev_id)
      render status: :bad_request if prev_item.nil?

      prev_item.update(next_id: id)
    end
    if next_id.present?
      next_item = PlaylistItem.find(next_id)
      render status: bad_request if next_item.nil?

      next_item.update(prev_id: id)
    end

    render json: playlist_item
  end

  # DELETE /playlists/:id
  def destroy_item
    playlist_item = PlaylistItem.find_by(entry_id: playlist_item_params[:entry_id], playlist_id: params[:id])
    render status: :bad_request if playlist_item.blank?

    if playlist_item[:prev_id].present?
      prev_item = PlaylistItem.find(playlist_item[:prev_id])
      prev_item.update(next_id: playlist_item[:next_id])
    end
    if playlist_item[:next_id].present?
      next_item = PlaylistItem.find(playlist_item[:next_id])
      next_item.update(prev_id: playlist_item[:prev_id])
    end

    playlist_item.destroy
  end

  # DELETE /playlists
  def destroy
    @playlist = Playlist.find(playlist_params[:id])
    if @playlist.nil? || @playlist[:user_id] != current_api_v1_user.id
      render status: :bad_request, json: {}
    else
      @playlist.destroy
      render status: :ok, json: {}
    end
  end

  private

  def set_playlist
    # TODO: private playlist
    @playlist = Playlist.includes(playlist_items: { entry: :bookmarks }).find(params[:id])
  end

  def playlist_params
    params.require(:playlist).permit(:id, :name, :is_private)
  end

  def playlist_update_params
    params.require(:playlist).permit(:name, :is_private)
  end

  def playlist_item_params
    params.require(:playlist_item).permit(:playlist_id, :entry_id, :prev_id, :next_id)
  end
end
