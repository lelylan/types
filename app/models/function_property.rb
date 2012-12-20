class FunctionProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  field :property_id, type: Moped::BSON::ObjectId
  field :expected, default: '{{expected}}'

  attr_accessor :uri
  attr_protected :property_id

  validates :uri, presence: true, uri: true, on: :create

  embedded_in :function

  before_create :set_property_id

  private

  def set_property_id
    self.property_id = find_id(uri)
  end
end
