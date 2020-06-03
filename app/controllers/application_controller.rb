# frozen_string_literal: true


class ApplicationController < ActionController::API
  before_action :authenticate_host!
  
  private

  #Use this method to verify that all api calls have a api key
  def authenticate_api
    
  end

end
