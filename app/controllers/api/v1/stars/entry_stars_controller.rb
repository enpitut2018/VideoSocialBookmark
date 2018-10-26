class Api::V1::Stars::EntryStarsController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :entry_star_params, only: [:create, :destroy]
  before_action :authenticate_api_v1_user!, only: [:create, :destroy]

  # POST /stars/entries/1
  def create
    entry_star = EntryStar.create(user_id: current_api_v1_user.id, entry_id: params[:entry_id])
    render json: entry_star
  end

  # DELETE /stars/entries/1
  def destroy
    entry_star = EntryStar.find_by(user_id: current_api_v1_user.id, entry_id: params[:entry_id])
    entry_star.destroy if entry_star 
  end

private:
  def entry_star_params
    params.require(:entry_id)
  end
end
