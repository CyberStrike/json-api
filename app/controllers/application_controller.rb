class ApplicationController < ActionController::API
  include ExceptionHandler

  attr_reader :current_user

  before_action :authorize_request

  private

  def authorize_request
    @current_user = Authenticate.request(request.headers)
  end
end