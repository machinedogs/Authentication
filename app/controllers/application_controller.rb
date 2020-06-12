# frozen_string_literal: true
class ApplicationController < ActionController::API
  before_action :authenticate_api

  private
  #Use this method to verify that all api calls have a api key
  def authenticate_api
    return true if params['API-KEY'] == '31dd93e788c040367cb7b9bba52ff9d489dee5f05f7548b9313dd2d12c7981035b67e02abad9194d16c25ac0a88634c742301c77a3e56e2a5826d8a6216621f5'
    render json: { error: 'API KEY NOT PROVIDED'}, status: :unauthorized
  end
end
