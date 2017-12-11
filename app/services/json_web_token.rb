class JsonWebToken
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i # set expiry to 24 hours from creation time
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    HashWithIndifferentAccess.new JWT.decode(token, HMAC_SECRET)[0]
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    raise ExceptionHandler::ExpiredSignature, e.message
  end
end