# frozen_string_literal: true


module Devise
  module Strategies
    class JWTAuthenticatable < Base # Here check if there is token present
      def authenticate!
        @user = AuthorizeApiRequest.call(params).result
        user ? success!(user) : fail!('Invalid email or password')
      end
    end
  end
end
