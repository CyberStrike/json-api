class Authenticate

  def self.user(email, password)
    user = User.find_by!(email: email)

    if user.authenticate(password)
      return JsonWebToken.encode(user_id: user.id)
    end

    # raise Authentication error if credentials are invalid
  rescue ActiveRecord::RecordNotFound, BCrypt::Errors::InvalidHash => e
    raise(ExceptionHandler::AuthenticationError, I18n.t(:invalid_credentials))
  end

  def self.request(headers = {})
    return User.find(decoded_auth_token(headers)[:user_id]) if decoded_auth_token(headers)
  rescue ActiveRecord::RecordNotFound => e
    raise( ExceptionHandler::InvalidToken,  ("#{I18n.t :invalid_token} #{e.message}") )
  end

  # decode authentication token
  def self.decoded_auth_token(headers = {})
    JsonWebToken.decode(http_auth_header(headers))
  end

  # check for token in `Authorization` header
  def self.http_auth_header(headers = {})
    has_auth_header = (headers['Authorization'].present? and not headers['Authorization'].blank?)
    has_valid_format = (headers['Authorization'].include?('Bearer') and headers['Authorization'].split(' ').count == 2)

    if has_auth_header and has_valid_format
      return headers['Authorization'].split(' ').last
    end

    raise(ExceptionHandler::MissingToken, I18n.t(:missing_token))
  rescue NoMethodError => e
    raise(ExceptionHandler::MissingToken, I18n.t(:missing_token))
  end
end