Devices::Application.routes.draw do
  root to: "users#new"

  # Authentication
  get "logout" => "sessions#destroy", as: "logout"
  get "login"  => "sessions#new",     as: "login"
  get "signup" => "users#new",        as: "signup"

  resources :users
  resources :sessions

  # API Resources
  resources :functions, defaults: {format: 'json'} do
    member do
      get    'properties' => 'function_properties#show'
      post   'properties' => 'function_properties#create'
      delete 'properties' => 'function_properties#destroy'
    end
  end
end
