# frozen_string_literal: true


require 'byebug'
module JsonWebToken
  def self.encode(payload, exp = 1.hours.from_now)
    payload[:exp] = exp.to_i
    encoded = {'jwt': JWT.encode(payload, secret_key), 'expires': 1.hours.from_now}
  end

  def self.refresh_encode(payload, exp = 2.months.from_now)
    payload[:exp] = exp.to_i
    encoded = {'refresh_token': JWT.encode(payload, secret_key), 'expires': 3.months.from_now}
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
