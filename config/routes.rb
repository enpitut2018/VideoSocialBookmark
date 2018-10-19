Rails.application.routes.draw do
	namespace :api do
		namespace :v1 do
			resources :bookmarks
		end
	end
	resources :bookmarks
	root to:'bookmarks#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :entries
      mount_devise_token_auth_for 'User', at: 'auth',
        controllers: {
          registrations: 'api/v1/auth/sign_up'
        }
    end
  end
end
