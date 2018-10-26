Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :bookmarks
      resources :entries, :only => :show
      get "/trend/:page", to: "trend#index"
      get "/trend/:page/preload", to: "trend#preload"
      post "/entries/:entry_id", to: "bookmarks#create_by_entry_id"
      resources :users
      get "/users/:id/bookmarks", to: "users#bookmarks"

      mount_devise_token_auth_for 'User', at: 'auth',
        controllers: {
          registrations: 'api/v1/auth/sign_up'
        }
    end
    match '*all', to: 'api#routing_error', via: [:get, :post]
  end

  root 'static_pages#index'
  match '*all', to: 'static_pages#index', via: [:get]
  get '/index', to: 'static_pages#index'
  get '*path', to: redirect('/')
end
