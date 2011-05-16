class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uri
  field :values, type: Array
  field :pending, default: 'false'

  attr_accessible :uri, :pending, :values

  validates :uri, presence: true, url: true
  validates :pending, inclusion: { in: %w(true false) }

  embedded_in :status

  def connection_uri
    "#{self.status.uri}/properties?uri=#{uri}"
  end
end
