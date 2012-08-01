class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Search::URI

  field :values, type: Array, default: []
  field :min_range
  field :max_range
  field :property_id

  attr_accessor :uri
  attr_protected :property_id

  validates :uri, presence: true, url: true

  embedded_in :status

  before_save :parse_values, :set_property_id

  private 

  def parse_values
    values.map!(&:to_s)
  end

  def set_property_id
    self.property_id = find_id(uri)
  end
end
