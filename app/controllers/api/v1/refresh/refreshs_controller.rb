# frozen_string_literal: true

class Api::V1::Refresh::RefreshsController < ApplicationController
    #Will take in expired JWT token(does it need to be an expired jwt token), and refresh token and return new JWT token and new refresh token
    def index 
        @refresh_tokens= JsonWebToken.decode(params[:refresh_token])
        #Check if refresh token is not expired
        
        if Time.at(@refresh_tokens[:exp]) > Time.now
            #If not expired, give back new JWT token and new refresh token
            render :refresh_tokens,:formats =>:json, status: :ok
        elsif @refresh_tokens[:refresh]!=true
            render json: { error: 'Token is not valid'}, status: :unauthorized
        else 
            render json: { error: 'Token is expired'}, status: :unauthorized
        end
    end
end

  