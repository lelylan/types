class StatusProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Array::Normalize

  before_create :normalize_array_on_create
  before_update :normalize_array_on_update

  field :uri
  field :pending, default: ""
  field :values, type: Array
  attr_accessible :uri, :pending, :values

  validates :uri, presence: true
  validates :uri, url: true
  validates :pending, inclusion: { in: ["", "true", "false"], allow_blank: true, message: "is not a valid boolean value, use true or false" }

  embedded_in :status, inverse_of: :status_properties

  def connection_uri
    self.status.uri + "/properties" + "?uri=" + uri
  end

end
