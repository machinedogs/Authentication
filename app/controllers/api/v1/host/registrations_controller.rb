# frozen_string_literal: true
class Api::V1::Host::RegistrationsController < Devise::RegistrationsController
      skip_before_action :authenticate_scope!

      # before_action :configure_sign_up_params, only: %i[create]
      # before_action :configure_account_update_params, only: %i[update]
      # GET /resource/sign_up
      def new
        super
      end

      # POST /resource
      def create
        params = host_params
        params[:profileImage]= 'https://images.unsplash.com/photo-1582266255765-fa5cf1a1d501?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80'
        @host_sign_up = Host.create(params)
        if @host_sign_up.save 
          GigMailer.with(email: params[:email].downcase).new_user_email.deliver_later
          render :host_sign_up,:formats =>:json, status: :ok
        else
          render json: {
            status: 'ERROR', message: 'Host Not Registered', data: @host_sign_up.errors
          },status: :unprocessable_entity
        end
      end

      # GET /resource/edit
      def edit
        super
      end

      # PUT /resource
      def update
        super
      end

      # DELETE /resource
      def destroy
        user = AuthorizeApiRequest.call(params).result
        if user
          user.destroy
          render json: {status: "User Deleted"}, status: :ok
        else
          render json: { error: "User Not Deleted" }, :status => 404
        end  
      end

      # GET /resource/cancel
      # Forces the session data which is usually expired after sign
      # in to be expired now. This is useful if the user wants to
      # cancel oauth signing in/up in the middle of the process,
      # removing all OAuth session data.
      def cancel
        super
      end

      protected

      # If you have extra params to permit, append them to the sanitizer.
      def configure_sign_up_params
        devise_parameter_sanitizer.permit(:sign_up, keys: %i[attribute])
      end

      # If you have extra params to permit, append them to the sanitizer.
      def configure_account_update_params
       devise_parameter_sanitizer.permit(:account_update, keys: %i[attribute])
      end

      # The path used after sign up.
      def after_sign_up_path_for(resource)
        super(resource)
      end

      # The path used after sign up for inactive accounts.
      def after_inactive_sign_up_path_for(resource)
        super(resource)
      end

      def host_params
        params.permit(:email, :name,  :password, :password_confirmation) 
      end
end

