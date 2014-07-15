class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  field :property_id, type: Moped::BSON::ObjectId
  field :pending, type: Boolean, default: false
  field :values, type: Array
  field :range, type: Hash

  attr_accessor :id
  attr_accessible :pending, :values, :range, :id

  validates :id, presence: true, on: :create

  embedded_in :status

  before_create :set_property_id, :parse_values

  private

  def set_property_id
    self.property_id = id
  end

  def parse_values
    self.values.map!(&:to_s) if values_changed?
  end
end
