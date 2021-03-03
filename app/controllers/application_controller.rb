# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from GameInvalidError, with: :unprocessable_entity_response
  rescue_from ActionController::ParameterMissing, with: :bad_request

  def bad_request(_exception)
    return head :bad_request
  end

  def unprocessable_entity_response(exception)
    render json: {error: exception.message}, status: :unprocessable_entity
  end
end
