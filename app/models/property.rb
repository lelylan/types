class Property
  include Mongoid::Document
  include Mongoid::Timestamps
  include Lelylan::Document::Base

  before_create :normalize_array_on_create
  before_update :normalize_array_on_update

  field :name
  field :uri
  field :created_from
  field :default
  field :values, type: Array, default: []

  attr_accessible :name, :default, :values

  validates :name, presence: true
  validates :uri, presence: true, url: true
  validates :created_from, presence: true, url: true
end
