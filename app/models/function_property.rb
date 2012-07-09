class FunctionProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value
  field :property_id

  attr_accessor :uri
  attr_accessible :value, :uri

  validates :uri, presence: true, url: true

  embedded_in :function

  before_save :set_property_id


  private

    def set_property_id
      self.property_id = Addressable::URI.parse(uri).basename
    end
end
