module AuthenticateSpecHelper
  # generate tokens from user id
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  # generate expired tokens from user id
  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  def valid_headers(id = user.id)
    {
      'Authorization' => "Bearer #{token_generator(id)}",
      'Content-Type' => 'application/json'
    }
  end

  def invalid_headers
    {
      'Authorization' => "Bearer",
      'Content-Type' => 'application/json'
    }
  end

end