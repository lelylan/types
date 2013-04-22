class FunctionProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  field :property_id, type: Moped::BSON::ObjectId
  field :value
  field :pending, type: Boolean, default: true

  attr_accessor :id
  attr_accessible :id, :value, :pending

  validates :id, presence: true, on: :create

  embedded_in :function

  before_create :set_property_id

  private

  def set_property_id
    self.property_id = id
  end
end
