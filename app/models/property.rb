class Property
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base
  include Lelylan::Array::Normalize

  before_create :normalize_array_on_create
  before_update :normalize_array_on_update

  field :name
  field :uri
  field :created_from
  field :default
  field :values, type: Array
  attr_accessible :name, :default, :values

  validates_presence_of :name
  validates_url :uri
  validates_url :created_from

end
