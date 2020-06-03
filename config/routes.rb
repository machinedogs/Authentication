# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :hosts,
             controllers: {
               sessions: 'host/sessions', registrations: 'host/registrations'
             }

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :users, only: %i[index create]
      resources :events, only: %i[index create hosts_events]
      get '/host/events' => 'events#host_events', as: :host_events
    end
  end
end
