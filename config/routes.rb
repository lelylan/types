LelylanType::Application.routes.draw do
  resources :properties, defaults: { format: 'json' }
end
