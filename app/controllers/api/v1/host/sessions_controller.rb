# frozen_string_literal: true

class Api::V1::Host::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create

    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      @host_sign_in = Host.where(email: params[:email]).first
      render :host_sign_in, :formats =>:json, status: :ok
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
