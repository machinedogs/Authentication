# frozen_string_literal: true
class Api::V1::Refresh::RefreshsController < ApplicationController
    #Will take in expired JWT token(does it need to be an expired jwt token), and refresh token and return new JWT token and new refresh token
    def index 
        @refresh_tokens= JsonWebToken.decode(params[:refresh_token])
        #Check if user is still a valid user 
        Host.find(@refresh_tokens[:host_id])
            #If nil, means token expired 
        if @refresh_tokens != nil
            #If not expired, give back new JWT token and new refresh token
            render :refresh_tokens,:formats =>:json, status: :ok
        else
            render json: { error: 'Token is expired'}, status: :unauthorized
        end
        rescue ActiveRecord::RecordNotFound
            render json: { error: 'User not found'}, status: :unauthorized
    end
end

  