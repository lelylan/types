class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  field :property_id, type: Moped::BSON::ObjectId
  field :value, type: Array, default: []
  field :pending, type: Boolean, default: false

  attr_accessor :uri
  attr_accessible :value, :pending, :uri

  validates :uri, presence: true, uri: true, on: :create

  embedded_in :status

  before_create :set_property_id, :parse_value

  private

  def set_property_id
    self.property_id = find_id(uri)
  end

  def parse_value
    self.value.map!(&:to_s) if value_changed?
  end
end
