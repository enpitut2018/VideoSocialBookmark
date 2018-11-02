# frozen_string_literal: true

class Api::V1::Stars::EntryStarsController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :set_entry_star, only: %i[show create destroy]
  before_action :authenticate_api_v1_user!, only: %i[show create destroy]

  # GET /stars/entries/:entry_id
  def show
    render json: { enabled: @entry_star.present? }
  end

  # POST /stars/entries/:entry_id
  def create
    redirect_to controller: "api", action: "routing_error" if @entry_star.present?

    @entry_star = EntryStar.new(user_id: current_api_v1_user.id,
                                entry_id: params[:entry_id])
    if @entry_star.save
      render json: @entry_star
    else
      redirect_to controller: "api", action: "routing_error"
    end
  end

  # DELETE /stars/entries/:entry_id
  def destroy
    @entry_star&.destroy
  end

  private

  def set_entry_star
    @entry_star = EntryStar.find_by(user_id: current_api_v1_user.id,
                                    entry_id: params[:entry_id])
  end
end
