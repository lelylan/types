class TypeFunction
  include Mongoid::Document

  field :uri
  attr_accessible :uri

  embedded_in :type, :inverse_of => :type_functions

  validates_presence_of :uri
  validates_url :uri

  def connection_uri
    self.type.uri + "/functions" + "?uri=" + uri
  end
end
