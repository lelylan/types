class TypeProperty
  include Mongoid::Document

  field :uri
  attr_accessible :uri

  embedded_in :type, :inverse_of => :type_properties

  validates_presence_of :uri
  validates_url :uri

  def connection_uri
    self.type.uri + "/properties" + "?uri=" + uri
  end
end
