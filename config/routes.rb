# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :hosts,
             controllers: {
               sessions: 'api/v1/host/sessions', registrations: 'api/v1/host/registrations'
             }
      get 'refresh', to: 'refresh/refreshs#index'
    end
  end     
end
