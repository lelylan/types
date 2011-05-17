class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uri
  field :values, type: Array, default: []
  field :pending, default: ''

  attr_accessible :uri, :pending, :values

  validates :uri, presence: true, url: true
  validates :pending, inclusion: { in: %w(true false), allow_blank: true }

  embedded_in :status

  def connection_uri
    "#{self.status.uri}/properties?uri=#{uri}"
  end
end
