class User
  include Mongoid::Document
  store_in session: 'default'
end
