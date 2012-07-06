LelylanType::Application.routes.draw do
  resource :properties, defaults: { format: 'json' }
end
