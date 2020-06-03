# frozen_string_literal: true


class Api::V1::EventsController < ApplicationController
  skip_before_action :authenticate_host!, only: [:index]
  include JsonWebToken
  #Create an event, need to be authenticated, and associate this event to this host 
  #Decode the jwt to get the host, and create the event for that host 
  def create
    #Get user
    @user = AuthorizeApiRequest.call(params).result
    @event = @user.event.create(event_params)
    if @event.save
      render :event, status: :ok
    else
      render json: {
        status: 'ERROR', message: 'Event Not Saved', data: event.errors
      },
             status: :unprocessable_entity
    end
  end

  # Gets created events
  def index
    @events = Event.all
    render :events, status: :ok
  end

  #This endpoint is protected, and needs to authenticate user
  def host_events
    @user = AuthorizeApiRequest.call(params).result
    @host_events = Event.where(host_id: @user.id)
    render :host_events, status: :ok
  end

  private

  def event_params
    params.permit(
      :title,
      :description,
      :date,
      :type_id,
      :latitude,
      :longitude
    )
  end
end
