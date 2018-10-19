Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :bookmarks
      resources :entries

      get "/ranking/:page", to: "ranking#index"

      mount_devise_token_auth_for 'User', at: 'auth',
        controllers: {
        registrations: 'api/v1/auth/sign_up'
      }
    end
  end
end
