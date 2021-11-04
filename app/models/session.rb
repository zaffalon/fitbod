#encoding: utf-8

class Session < ApplicationRecord
  belongs_to :user

  TTL = 600.minutes

  before_create do |session|
    self.token = create_jwt
  end

  def create_jwt(payload = {}, secret=Rails.application.secrets.secret_key_base)
    # User attributes
    payload[:user] = {}
    payload[:user][:email] = self.user.email

    # Issued at (iat)
    payload[:iat] = Time.current.to_i

    # Expiration (exp)
    payload[:exp] = self.expiry_at.to_i

    return JWT.encode(payload, secret)
  end

  def decode_jwt(token = self.token, secret=Rails.application.secrets.secret_key_base, verify=true)
    decoded_token = JWT.decode(token, secret, verify, {})
    return decoded_token.first

  rescue JWT::ExpiredSignature => error
    self.errors.add(:token, error.message)

    return false

  rescue Exception => error
    self.errors.add(:token, error.message)
    return false
  end
end
