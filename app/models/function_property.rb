class FunctionProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uri
  field :values, type: Array, default: []
  field :secret, default: 'false'
  field :before, default: 'false'

  attr_accessible :uri, :values, :secret, :before

  embedded_in :function, inverse_of: :function_properties

  validates :uri, presence: true, url: true
  validates :secret, inclusion: { in: %w(true false) }
  validates :before, inclusion: { in: %w(true false) }
end
