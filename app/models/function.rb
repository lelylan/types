# TODO: remember index definition

class Function

  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from
  attr_accessible :name

  embeds_many :function_properties

  validates :name, presence: true
  validates :uri, url: true
  validates :created_from, url: true

  def properties_uri
    self.uri + "/properties"
  end

end

