class FunctionProperty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value
  field :property_id

  attr_accessor :uri
  attr_protected :property_id

  validates :uri, presence: true, url: true

  embedded_in :function

  private

  def property_id=(property_id)
    write_attribute :property_id, find_id(uri)
  end
end
