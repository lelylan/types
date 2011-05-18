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

  def connection_uri
    "#{self.status.uri}/properties?uri=#{uri}"
  end
end
