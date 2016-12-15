Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'google_apis#index'
  resource :google_apis do
    get :people_callback
    get :people_auth
    get :contacts_callback
    get :contacts_auth
  end
end
