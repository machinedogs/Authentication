# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :hosts,
             controllers: {
               sessions: 'host/sessions', registrations: 'host/registrations'
             }
end
