class FunctionProperty
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Array::Normalize

  before_create :normalize_array_on_create
  before_update :normalize_array_on_update

  field :uri
  # TODO: why is this an array and not a simple value?
  # Maybe it have some connection related with the status
  # Search more, can't remember :)
  field :values, type: Array
  field :secret, default: "false"
  field :before, default: "false"
  attr_accessible :uri, :values, :secret, :before

  embedded_in :function, inverse_of: :function_properties

  validates :uri, presence: true
  validates :uri, url: true

  validates_inclusion_of :secret, in: ["true", "false"], allow_blank: true, message: "is not a valid boolean value, use true or false"
  validates_inclusion_of :before, in: ["true", "false"], allow_blank: true, message: "is not a valid boolean value, use true or false"

  def connection_uri
    self.function.uri + "/properties" + "?uri=" + uri
  end

end
