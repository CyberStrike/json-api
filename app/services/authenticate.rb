class Authenticate

  # Service entry point - return valid user object
  def call
    {
        user: check
    }
  end

  def self.user(email, password)
    found_user = User.find_by(email: email)
    return JsonWebToken.encode(user_id: found_user.id) if found_user && found_user.authenticate(password)
    # raise Authentication error if credentials are invalid
    raise(ExceptionHandler::AuthenticationError, I18n.t(:invalid_credentials))
  end

  def self.request(headers = {})
    User.find(decoded_auth_token(headers)[:user_id]) if decoded_auth_token(headers)
  rescue ActiveRecord::RecordNotFound => e
    raise( ExceptionHandler::InvalidToken,  ("#{I18n.t :invalid_token} #{e.message}") )
  end

  # decode authentication token
  def self.decoded_auth_token(headers = {})
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header(headers))
  end

  # check for token in `Authorization` header
  def self.http_auth_header(headers = {})
    if headers['Authorization'].present? and not headers['Authorization'].blank?
      return headers['Authorization'].split(' ').last
    end
    raise(ExceptionHandler::MissingToken, I18n.t(:missing_token))
  end
end