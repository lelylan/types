class User
  include Mongoid::Document
  store_in session: 'people'

  field :rate_limit
end
