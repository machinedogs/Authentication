# frozen_string_literal: true

# app/commands/authorize_api_request.rb


class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(params = {})
    @params = params
  end

  def call
    user
  end

  private

  attr_reader :params

  def user
    @user ||= Host.find(decoded_auth_token[:host_id]) if decoded_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
    rescue ActiveRecord::RecordNotFound => e
      return nil
  end

  def decoded_auth_token
    decoded_auth_token = JsonWebToken.decode(http_auth_header)
    #See if it decodes correctly, meaning not expired, then check if it is a refresh token or not
    if decoded_auth_token && decoded_auth_token[:refresh]
      return decoded_auth_token
    else
      return nil
    end
  end

  def http_auth_header
    if params['refresh_token'].present?
      params['refresh_token'].split(' ').last
    else
      errors.add :token, 'Missing token'
    end
  end
end
