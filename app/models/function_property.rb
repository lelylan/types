class FunctionProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value
  field :property_id
  field :property_uri # used only to easily check validations

  attr_accessible :value, :property_uri

  validates :property_uri, presence: true, url: true, uniqueness: true

  embedded_in :function

  before_save :set_property_id

  def set_property_id
    self.property_id = Addressable::URI.parse(property_uri).basename
  end
end
