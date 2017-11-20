class AuthenticationController < ApplicationController

  def login
    auth_token = Authenticate.user(auth_params[:email], auth_params[:password])
    render json: {token: auth_token}, status: :accepted
  end

  private

  def auth_params
    params.permit(:email, :password)
  end

end
