LelylanType::Application.routes.draw do
  resources :properties, defaults: { format: 'json' }
  resources :functions, defaults: { format: 'json' }
  resources :statuses, defaults: { format: 'json' }
  resources :types, defaults: { format: 'json' }
end
