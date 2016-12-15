Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'google_api#index'
  resource :google_api do
    get :people_api_callback
    get :people_api_auth
  end
end
