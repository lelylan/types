Devices::Application.routes.draw do
  root to: "users#new"

  # Authentication
  get "logout" => "sessions#destroy", as: "logout"
  get "login"  => "sessions#new",     as: "login"
  get "signup" => "users#new",        as: "signup"

  resources :users
  resources :sessions

  # API Resources
  resources :types, defaults: {format: 'json'}
  resources :properties, defaults: {format: 'json'}
  resources :functions, defaults: {format: 'json'} do
    member do
      get    'properties' => 'function_properties#show'
      post   'properties' => 'function_properties#create'
      delete 'properties' => 'function_properties#destroy'
    end
  end
  resources :statuses, defaults: {format: 'json'} do
    member do
      get    'properties' => 'status_properties#show'
      post   'properties' => 'status_properties#create'
      delete 'properties' => 'status_properties#destroy'
    end
  end
  get    'statuses/:id/image(.:format)' => 'status_image#show',    defaults: { format: 'png' }
  post   'statuses/:id/image(.:format)' => 'status_image#create',  defaults: { format: 'png' }
  delete 'statuses/:id/image(.:format)' => 'status_image#destroy', defaults: { format: 'png' }
end
