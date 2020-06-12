# frozen_string_literal: true
class Api::V1::Refresh::RefreshsController < ApplicationController
    #Will take in refresh token and give back new auth token and refresh token
    def index 
        @refresh_tokens= JsonWebToken.decode(params[:refresh_token])
        #Check if user is still a valid user 
        Host.find(@refresh_tokens[:host_id])
        #If token not expired and token is refresh token 
        if @refresh_tokens != nil && @refresh_tokens[:refresh]
            #If not expired, give back new JWT token and new refresh token
            render :refresh_tokens,:formats =>:json, status: :ok
        else
            render json: { error: 'Token is expired'}, status: :unauthorized
        end
        rescue ActiveRecord::RecordNotFound
            render json: { error: 'User not found'}, status: :unauthorized
    end
end

  