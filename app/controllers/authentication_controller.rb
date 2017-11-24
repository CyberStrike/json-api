class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, except: :validate

  def login
    token = Authenticate.user(auth_params[:email], auth_params[:password])
    render json: { token: token }, status: :accepted
  end

  def register
    user = User.create!(register_params)
    token = Authenticate.user(user.email, user.password)
    response = { message: I18n.t(:account_created), token: token }
    render json: response, status: :created
  end

  def validate
    render json: { message: I18n.t(:valid_request)}, status: :accepted
  end

  private

  def auth_params
    params.permit(:email, :password)
  end

  def register_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

end
