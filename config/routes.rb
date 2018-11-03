# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Users
      get "/current_user", to: "users#current_user_show"
      get "/current_user/icon", to: "users#current_user_icon"
      resources :users, only: [:show] do
        member do
          get "bookmarks"
        end
      end

      # Bookmarks
      resources :bookmarks, only: :destroy

      # Comments
      resources :comments, only: %i[update destroy]

      # Entries
      get "/entries/:entry_id/comments", to: "comments#index"
      post "/entries/:entry_id/comments", to: "comments#create"
      resources :entries, only: %i[show create update]

      # Stars
      namespace :stars do
        get "/entries/:entry_id", to: "entry_stars#show"
        post "/entries/:entry_id/", to: "entry_stars#create"
        delete "/entries/:entry_id/", to: "entry_stars#destroy"
      end

      # Search
      get "/search/entry", to: "search#entry"

      # Trends
      get "/trend/:page", to: "trend#index"
      get "/trend/:page/preload", to: "trend#preload"

      # Auth
      mount_devise_token_auth_for "User", at: "auth",
                                          controllers: {
                                            registrations: "api/v1/auth/sign_up"
                                          }
    end

    match "*all", to: "api#routing_error", via: %i[get post]
  end

  root "static_pages#index"
  match "*all", to: "static_pages#index", via: %i[get]
  get "/index", to: "static_pages#index"
  get "*path", to: redirect("/")
end
