# frozen_string_literal: true

class Api::ApiController < ActionController::API
  def routing_error
    render json: { error: "Routing Not Found", status: 404 }, status: :not_found, content_type: "text/json"
  end
end
