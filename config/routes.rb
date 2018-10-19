Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :entries
      mount_devise_token_auth_for 'User', at: 'auth',
        controllers: {
          registrations: 'api/v1/auth/sign_up'
        }
      get '*path', controller: 'api', action: 'rooting_error'
    end
  end

  root 'static_pages#index'
  match '*all', to: 'static_pages#index', via: [:get]
  get '/index', to: 'static_pages#index'
  get '*path', to: redirect('/')
end
