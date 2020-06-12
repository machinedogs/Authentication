# frozen_string_literal: true
class ApplicationController < ActionController::API
  # before_action :authenticate_api

  # private
  # #Use this method to verify that all api calls have a api key
  # def authenticate_api
  #   return true if params['API_KEY'] == APP_CONFIG['API_KEY']
  #   render json: { error: 'API KEY NOT PROVIDED'}, status: :unauthorized
  # end
end
