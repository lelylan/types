class TypeStatus
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uri
  attr_accessible :uri

  embedded_in :type, :inverse_of => :type_statuses

  validates_presence_of :uri
  validates_url :uri

  def connection_uri
    self.type.uri + "/statuses" + "?uri=" + uri
  end
end
