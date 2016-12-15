Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'google_apis#index'
  resource :google_apis do
    get :people_callback
    get :people_auth
  end
end
