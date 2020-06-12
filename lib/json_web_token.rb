# frozen_string_literal: true
module JsonWebToken
  def self.encode(payload, exp = 1.hours.from_now)
    payload[:exp] = exp.to_i
    payload[:refresh]=false
    encoded = {'jwt': JWT.encode(payload, secret_key), 'expires': payload[:exp]}
  end

  def self.refresh_encode(payload, exp = 3.months.from_now)
    payload[:exp] = exp.to_i
    payload[:refresh]=true
    encoded = {'refresh_token': JWT.encode(payload, secret_key), 'expires': payload[:exp]}
  end

  def self.decode(token)
    body = JWT.decode(token, secret_key)[0]
    HashWithIndifferentAccess.new body
  rescue StandardError
    nil
  end

  def self.secret_key
    APP_CONFIG['SECRET_KEY']
  end
end
