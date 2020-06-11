# frozen_string_literal: true

class AuthenticateUser
  include JsonWebToken
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  # Returns a jwt token if the user method  is successful
  def call
    JsonWebToken.encode(host_id: user.id) if user
  end

  private

  attr_accessor :email, :password

  def user
    host = Host.find_by_email(email.downcase)
    return host if host&.valid_password?(password)

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end
