class FunctionProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :property_id
  field :value, default: ''

  attr_accessible :property_id, :value

  #embedded_in :function, inverse_of: :function_properties

  #validates :uri, presence: true, url: true
  #validates :secret, inclusion: { in: [true, false] }
  #validates :filter, inclusion: { in: %w(before), allow_blank: true }
  #validates :uri, uniqueness: true

  #def connection_uri
    #"#{self.function.uri}/properties?uri=#{uri}"
  #end
end
