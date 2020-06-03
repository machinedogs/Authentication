# frozen_string_literal: true


class Api::V1::UsersController < ApplicationController # Create User
  def create
    user = User.create(user_params)
    if user.save
      render json: { status: 'SUCCESS', message: 'Saved User', data: user },
             status: :ok
    else
      render json: {
        status: 'ERROR', message: 'User Not Saved', data: user.errors
      },
             status: :unprocessable_entity
    end
  end

  # Gets user, created this action for debugging purposes, will not be needed in production environment
  def index
    users = User.all
    render json: { status: 'SUCCESS', message: 'Loaded Users', data: users },
           status: :ok
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      created_events: [], saved_events: []
    )
  end
end
