# frozen_string_literal: true



module JsonWebToken
  def self.encode(payload, exp = 24.hours.from_now)
    puts "Payload Here"
    puts payload 
    puts "Payload ^"
    payload[:exp] = exp.to_i
    JWT.encode(payload, secret_key)
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
