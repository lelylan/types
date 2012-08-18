class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  field :property_id, type: Moped::BSON::ObjectId
  field :values, type: Array
  field :min
  field :max

  attr_accessor :uri, :range
  attr_protected :property_id

  validates :uri, presence: true, uri: true, on: :create

  embedded_in :status

  before_create :set_property_id, :parse_values, :parse_range

  private 

  def parse_values
    self.values.map!(&:to_s) if values
  end

  def parse_range
    self.min = range[:min] if range
    self.max = range[:max] if range
  end

  def set_property_id
    self.property_id = find_id(uri)
  end
end
