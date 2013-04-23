require 'sidekiq/web'

Types::Application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'

  resources :properties, defaults: { format: 'json' } do
    match :public, via: :get, on: :collection
  end

  resources :functions, defaults: { format: 'json' } do
    match :public, via: :get, on: :collection
  end

  resources :statuses, defaults: { format: 'json' } do
    match :public, via: :get, on: :collection
  end

  resources :types, defaults: { format: 'json' } do
    match :public, via: :get, on: :collection
  end

  get '/categories' => 'categories#index'
end
