Devices::Application.routes.draw do
  root to: "users#new"

  # Authentication
  get "logout" => "sessions#destroy", as: "logout"
  get "login"  => "sessions#new",     as: "login"
  get "signup" => "users#new",        as: "signup"

  resources :users
  resources :sessions

  # API Resources
  get 'types/public' => 'types#index', public: 'true', defaults: {format: 'json'}
  resources :types, defaults: {format: 'json'}
  resources :properties, defaults: {format: 'json'}
  resources :functions, defaults: {format: 'json'} do
    member do
      get    'properties' => 'function_properties#show'
      post   'properties' => 'function_properties#create'
      delete 'properties' => 'function_properties#destroy'
    end
  end
  put 'statuses/device(.:format)' => 'status_device#update', defaults: { format: 'json' }
  resources :statuses, defaults: {format: 'json'} do
    member do
      get    'properties' => 'status_properties#show'
      post   'properties' => 'status_properties#create'
      delete 'properties' => 'status_properties#destroy'
      get    'image' => 'status_image#show'
      put   'image' => 'status_image#update'
      delete 'image' => 'status_image#destroy'
    end
  end
  get 'categories/public' => 'categories#index', public: 'true', defaults: {format: 'json'}
  resources :categories, defaults: {format: 'json'}
end
