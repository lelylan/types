class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Resourceable

  field :values, type: Array, default: []
  field :min_range
  field :max_range
  field :property_id, type: Moped::BSON::ObjectId

  attr_accessor :uri
  attr_protected :property_id

  validates :uri, presence: true, url: true, on: :create

  embedded_in :status

  before_create :parse_values, :set_property_id

  private 

  def parse_values
    values.map!(&:to_s)
  end

  def set_property_id
    self.property_id = find_id(uri)
  end
end
