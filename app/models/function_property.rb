class FunctionProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value, default: ''
  field :property_id

  attr_accessible :property_id, :value

  embedded_in :function

  validates :property_id, presence: true, uniqueness: true
end
