# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from GameInvalidError, with: :unprocessable_entity_response
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActiveRecord::RecordNotUnique, with: :not_unique_response
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def bad_request(_)
    head :bad_request
  end

  def unprocessable_entity_response(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def not_unique_response(_)
    head :conflict
  end

  def not_found_response(_)
    head :not_found
  end
end
