class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  field :property_id, type: Moped::BSON::ObjectId
  field :values, type: Array
  field :pending, type: Boolean, default: false
  field :range, type: Hash

  attr_accessor :uri
  attr_accessible :values, :pending, :range, :uri

  validates :uri, presence: true, uri: true, on: :create

  embedded_in :status

  before_create :set_property_id, :parse_values

  private

  def set_property_id
    self.property_id = find_id(uri)
  end

  def parse_values
    self.values.map!(&:to_s) if values_changed?
  end
end
