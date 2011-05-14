class Type
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  field :name
  field :uri
  field :created_from
  attr_accessible :name

  embeds_many :type_properties
  embeds_many :type_functions
  embeds_many :type_statuses

  validates :name, presence: true
  validates :uri, url: true
  validates :created_from, url: true

  def properties_uri
    self.uri + "/properties"
  end

  def functions_uri
    self.uri + "/functions"
  end

  def statuses_uri
    self.uri + "/statuses"
  end
end
