# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :comments, only: %i[index create]
      resources :bookmarks, only: %i[create]
      resources :entries, only: %i[show]
      resources :users
      get '/entries/:entry_id/comments', to: 'comment#index'
      post '/entries/:entry_id/comments', to: 'comment#create'
      get '/trend/:page', to: 'trend#index'
      get '/trend/:page/preload', to: 'trend#preload'

      post '/entries', to: 'entries#create'

      get '/current_user', to: 'users#index'
      get '/current_user/icon', to: 'users#index_user_icon'
      get "/users/:id/bookmarks", to: "users#bookmarks"

      mount_devise_token_auth_for 'User', at: 'auth',
                                          controllers: {
                                            registrations: 'api/v1/auth/sign_up'
                                          }
    end

    match '*all', to: 'api#routing_error', via: %i[get post]
  end

  root 'static_pages#index'
  match '*all', to: 'static_pages#index', via: %i[get]
  get '/index', to: 'static_pages#index'
  get '*path', to: redirect('/')
end
