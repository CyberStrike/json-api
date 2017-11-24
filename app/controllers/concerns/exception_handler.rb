module ExceptionHandler
  extend ActiveSupport::Concern

  class InvalidToken < StandardError; end
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class ExpiredSignature < StandardError; end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ActionController::ParameterMissing, with: :unprocessable_entity
    rescue_from ExceptionHandler::InvalidToken, with: :unprocessable_entity
    rescue_from ExceptionHandler::MissingToken, with: :unprocessable_entity
    rescue_from ExceptionHandler::ExpiredSignature, with: :unprocessable_entity
    rescue_from ExceptionHandler::AuthenticationError do |error|
      render json: { message: error.message }, status: :unauthorized
    end
    rescue_from ActiveRecord::RecordNotFound do |error|
      render json: {message: error.message}, status: :not_found
    end
  end

  private

  def unprocessable_entity ( error )
    render json: {message: error.message}, status: :unprocessable_entity
  end
end