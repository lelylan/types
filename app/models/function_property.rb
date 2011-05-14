class FunctionProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uri
  field :name
  field :created_from
  field :value
  field :secret, default: 'false'
  field :before, default: 'false'

  attr_accessible :uri, :value, :secret, :before

  embedded_in :function, inverse_of: :function_properties

  validates :uri, presence: true, url: true
  validates :secret, inclusion: { in: %w(true false) }
  validates :before, inclusion: { in: %w(true false) }

  def connection_uri
    "#{self.function.uri}/properties?uri=#{uri}"
  end  
end
