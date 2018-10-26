class Api::V1::EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :update, :destroy]

  # GET /entries/1
  def show
    render json: @entry, include: ['bookmarks', 'bookmarks.user']
  end

  # PATCH/PUT /entries/1
  def update
    if @entry.update(entry_params)
      render json: @entry
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /entries/1
  def destroy
    @entry.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
      @entry[:num_of_bookmarked] = @entry.count_bookmarks
    end

    # Only allow a trusted parameter "white list" through.
    def entry_params
      params.fetch(:entry, {}).permit(:id)
    end
end
