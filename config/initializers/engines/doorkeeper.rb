# Doorkeeper models extensions
Types::Application.config.to_prepare do
  Doorkeeper::AccessToken.class_eval { store_in session: 'people' }
  Doorkeeper::AccessGrant.class_eval { store_in session: 'people' }
  Doorkeeper::Application.class_eval { store_in session: 'people' }
end
