class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def routing_error
      render json: { error: 'Routing Not Found', status: 404 }, status: 404, content_type: 'text/json'
  end
end
