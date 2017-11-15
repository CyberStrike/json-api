module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ActionController::ParameterMissing, with: :unprocessable_entity

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: {message: e.message}, status: :not_found
    end
  end

  private

  def unprocessable_entity ( e )
    render json: {message: e.message}, status: :unprocessable_entity
  end
end