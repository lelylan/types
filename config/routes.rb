Types::Application.routes.draw do
  resources :properties, defaults: { format: 'json' } do
    match :public, via: :get, on: :collection
  end

  resources :functions, defaults: { format: 'json' } do
    match :public, via: :get, on: :collection
  end

  resources :statuses, defaults: { format: 'json' } do
    match :public, via: :get, on: :collection
  end

  resources :categories, defaults: { format: 'json' } do 
    match :public, via: :get, on: :collection
  end

  resources :types, defaults: { format: 'json' } do
    match :public, via: :get, on: :collection
  end
end
