class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :values, type: Array, default: []
  field :pending
  field :range_start, type: Float
  field :range_end, type: Float
  field :property_id

  attr_accessible :uri, :pending, :values, :range_start, :range_end, :property_id

  # TODO: whatever outside of true and false seems to become nill
  validates :pending, inclusion: { in: ['true', 'false'], allow_nil: true }
  validates :property_id, presence: true, uniqueness: true

  embedded_in :status

  before_save :parse_values

  def parse_values
    values.map!(&:to_s)
  end
end
