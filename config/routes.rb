Rails.application.routes.draw do
	namespace :api do
		namespace :v1 do
			resources :bookmarks
		end
	end
	resources :bookmarks
	root to:'bookmarks#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
