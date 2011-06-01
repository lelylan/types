class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uri
  field :values, type: Array, default: []
  field :pending, type: Boolean

  attr_accessible :uri, :pending, :values

  validates :uri, presence: true, url: true
  validates :pending, inclusion: { in: [true, false], allow_nil: true }

  embedded_in :status
  
  before_save :parse_values


  def connection_uri
    "#{self.status.uri}/properties?uri=#{uri}"
  end

  def parse_values
    values.map!(&:to_s)
  end
end
