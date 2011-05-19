class FunctionProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uri
  field :value, default: ''
  field :secret, type: Boolean, default: false
  field :before, type: Boolean, default: false

  attr_accessible :uri, :value, :secret, :before

  embedded_in :function, inverse_of: :function_properties

  validates :uri, presence: true, url: true
  validates :secret, inclusion: { in: [true, false] }
  validates :before, inclusion: { in: [true, false] }

  def connection_uri
    "#{self.function.uri}/properties?uri=#{uri}"
  end  
end
